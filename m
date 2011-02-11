Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab1BKICG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:02:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38264 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1BKICE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:02:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=bHwH2O5Qfw99rKlxlBdwRS58gCX5/LNw67Hxqgg6g+iyl+5p5eoWpWwPMfa+n5tr/N
         n//uqc+/bzsq96qumgQKQrFWGk3AuSpSxpXmY/lX5wzIPITvEEGHFy+eEtXk0wVb05jR
         8xLZawHOHLpm7IvsSTZX2gw85WziYub2HBlYs=
Date: Fri, 11 Feb 2011 11:01:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Klaas Neirinck <klaas.neirinck@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: tidspbridge: fixed several coding style issues
Message-ID: <20110211080138.GG4384@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Klaas Neirinck <klaas.neirinck@gmail.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1297382566-18748-1-git-send-email-klaas.neirinck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297382566-18748-1-git-send-email-klaas.neirinck@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 01:02:46AM +0100, Klaas Neirinck wrote:
> Fixed several coding style issues.
> 
> Signed-off-by: Klaas Neirinck <klaas.neirinck@gmail.com>
---  				dest = ibuf.bufr;
>  #ifdef OPT_ZERO_COPY_LOADER
>  				zero_copy = false;
> -				if (!dload_check_type(sptr, DLOAD_CINIT) {
> +				if (!dload_check_type(sptr, DLOAD_CINIT)) {
>  					dlthis->myio->writemem(dlthis->myio,
>  							       &dest,

Also it apparently fixes a compile problem?  Why not say that in the
change log...  :/

regards,
dan carpenter

