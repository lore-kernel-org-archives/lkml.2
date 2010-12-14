Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab0LNEn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 23:43:29 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55272 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab0LNEn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 23:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UhgSTcdwhG/gfOVOUnipMbCB3mVdFkLhHEmP5Yw0t+TxcPKWTO5n1veMRb1VzsK1id
         LctSYoEaIyp55nvmm1QH74/B2rS/bbzZmQWR78WF7NdjhBhRU55qgFnAl+rV0+Xla9mC
         83FdxVnqb/2Zk2tjYUj+h15qtUK9Bz6NgAPJU=
Subject: Re: [PATCH 1/2] Staging: vme_ca91cx42: use __dev{init,exit} for
 ->probe/remove
From: Namhyung Kim <namhyung@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martyn Welch <martyn.welch@ge.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101213182656.GA4645@kroah.com>
References: <1292141068-31458-1-git-send-email-namhyung@gmail.com>
	 <20101213182656.GA4645@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 13:43:19 +0900
Message-ID: <1292301799.1696.22.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-12-13 (월), 10:26 -0800, Greg KH:
> On Sun, Dec 12, 2010 at 05:04:27PM +0900, Namhyung Kim wrote:
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  drivers/staging/vme/bridges/vme_ca91cx42.c |   12 +++++++-----
> 
> This patch does not apply to the linux-next tree, what did you generate
> it against?
> 

Argh.. sorry, it was Linus's tree. Will resend if you want.


> Also, why are you marking these functions, is it really needed?  Same
> thing for your 2/2 patch.
> 

?? Maybe I don't get what you mean exactly.. They are hotplugging
stuffs, right? So shouldn't they be marked as such?


-- 
Regards,
Namhyung Kim


