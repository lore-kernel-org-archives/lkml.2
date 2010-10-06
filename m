Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0JFEex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:34:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60359 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab0JFEew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=IKG5RxSUwCI34pwilk+Duaka5VIZtJCGxV8jn6+trwL366Fo6ERNCVlbSjhWYmdopR
         BAOutJsu4TrSH0paVOrJUT+KyrXG85ulGYDmxRed0DMdPK4tgG3sv12QkGNzsOTsbvEa
         UF7JitPvOEpM+xV+cPpcTLadpooLh9r7+8mNA=
Date: Wed, 6 Oct 2010 06:34:10 +0200
From: Dan Carpenter <error27@gmail.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: greg@kroah.com, abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/28] Staging: comedi: drivers: adl_pci9111.c: Edit
	file so that checkpatch.pl has 30 warnings and 3 errors
Message-ID: <20101006043409.GA5409@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Tracey Dent <tdent48227@gmail.com>, greg@kroah.com,
	abbotti@mev.co.uk, fmhess@users.sourceforge.net,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1286326843-6170-1-git-send-email-tdent48227@gmail.com> <1286326843-6170-19-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286326843-6170-19-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:00:34PM -0400, Tracey Dent wrote:
>  
>  #define pci9111_ai_channel_get()					\
> -  (inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
> -   &PCI9111_CHANNEL_MASK)
> +	(inb(PCI9111_IO_BASE+PCI9111_REGISTER_AD_CHANNEL_READBACK)		\
> +		&PCI9111_CHANNEL_MASK)
                                                                               ^^^

That slash used to line up nicely with the slash from the line before.

regards,
dan carpenter

