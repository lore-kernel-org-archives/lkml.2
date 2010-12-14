Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab0LNQVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:21:09 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:51346 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757597Ab0LNQVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:21:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H8LZWBgx6FPDIttsWPJUpefcdymqQdXP4zymBHDAlKvwvozsa7ToS3W6btUnNvY+4o
         33A9o6DHUzhZFYwOKQ7fuBp1Xp4fl1iV2zs0KlDRoFHqkNX/xaFuCzbfkphIP6i5boLW
         VqqzoUMs8R3jJ98FY2+JPhNYroTUGGa/c2t2s=
Date: Tue, 14 Dec 2010 17:21:00 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MeeGo-dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to
 2.6.35
Message-ID: <20101214162100.GA10667@riccoc20.at.omicron.at>
References: <4C612AA4.5040100@dsn.okisemi.com>
 <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com>
 <20100817090637.GC3330@riccoc20.at.omicron.at>
 <201008171325.55761.arnd@arndb.de>
 <884C7BF624424621917562DB0C3E15E7@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <884C7BF624424621917562DB0C3E15E7@hacdom.okisemi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 04:46:03PM +0900, Tomoya MORINAGA wrote:
> We want to implement IEEE1588 driver for Intel EG20T PCH (Topcliff)
> using PTP core according to you saying.

That is good news.

> However, it seems PTP core module is not accepted by upstream.
> How about your PTP status ?

I posted v6 back on September 23. Based on the comments, I think the
patch set is almost good enough for mainline inclusion (at least, I
hope so).

I am just getting ready to post v7, and the kernel interface will
change a bit. I will post it before Christmas, so perhaps you can wait
a bit. You can take look at the v6 code, since the general ideas will
not change very much.

Thanks,
Richard
