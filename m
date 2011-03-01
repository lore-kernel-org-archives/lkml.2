Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab1CAUA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:00:27 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43754 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1CAUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:00:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=FcAZLCUhb6Sf8LIUEL1gMlia7L52K7PgeqJkkqTbaFNasTmzr3V1JZ9F9SIvjoGlPU
         TgKPqugTiOcCKJk2pjM1/e16OL1IS97xuM/oUXhTxoB+yQAJdSK/+uWswJRdZBK2iZqt
         8316cij0bDkr4AOuyG7IRwbOhaX5gBWm8fDxc=
Date: Tue, 1 Mar 2011 23:00:06 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        acho@novell.com
Subject: Re: [PATCH] Staging: keucr: Remove all type defines
Message-ID: <20110301200006.GX18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roel Van Nyen <roel.vannyen@gmail.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	acho@novell.com
References: <1299007790-5315-1-git-send-email-roel.vannyen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299007790-5315-1-git-send-email-roel.vannyen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 08:29:50PM +0100, Roel Van Nyen wrote:
> Remove all type defines from driver and replace them with kernel built-in types.
> 
> Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>

Some of your other patches were merged so this doesn't apply to
linux-next any more.

> -typedef u8 BOOLEAN;

It might be better to use bool type or int for boolean variables.  But
that can't be done automatically, it has to be audited carefully.  I
don't feel strongly about this, I'm just throwing it out there as food
for thought.  You are using the remove-typedef program btw?

regards,
dan carpenter
