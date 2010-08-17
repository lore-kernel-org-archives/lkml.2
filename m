Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0HQGaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:30:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63612 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0HQGaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=sw/idVymq1HIdRz3DbaCnWEQuV9kXhJu+NRWxtN0wvfguW6T6amlNc9gBCfO+Pwcrq
         2Qb33FXkamP+00/kXHyYg8RzyMWeSlrVZEtZG3ucRDkE6Tmti/BQMfLbYGpEn2Siuy/T
         OxNbdNjnx5QK8V/pV7TOyz3qZNxeQ8cbINbMc=
Date: Tue, 17 Aug 2010 08:29:40 +0200
From: Dan Carpenter <error27@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [patch] pata_winbond: fix module init
Message-ID: <20100817062830.GF645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk
References: <20100803152549.GQ26313@bicker> <201008162123.03208.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008162123.03208.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 09:23:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi Dan,
> 
> On Tuesday 03 August 2010 05:27:47 pm Dan Carpenter wrote:
> > winbond_init_one() returns 0 on success and an error code on failure.
> > In the original code, we always just released the regions and return
> > -ENODEV.  This was introduce in 2006 by 7e45b0e5f6f6 "[PATCH] libata:
> > Winbond support".
> 
> You might like to pick up
> 
> 	http://patchwork.ozlabs.org/patch/39358/
> 
> instead..
> 

I don't have the hardware, but yes, probably it's better to replace this
driver since it has never been able to load.

regards,
dan carpenter

