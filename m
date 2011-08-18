Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1HRDUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:20:01 -0400
Received: from mail07-md.ns.itscom.net ([175.177.155.117]:46167 "EHLO
	mail07-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab1HRDT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:19:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes with linux-3.1-rc2
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Jeff Layton <jlayton@samba.org>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
In-Reply-To: <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan> <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
Date: Thu, 18 Aug 2011 12:19:52 +0900
Message-ID: <3300.1313637592@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Justin Piszcz:
> Does anyone know if any kernel supports CIFS w/out crashing? I'd like to 
> backup some CIFS shares, thanks.
>
>
> mount -t cifs //w2/x /mnt -o user=user,pass=pass
>
> [  881.388836] CIFS VFS: cifs_mount failed w/return code = -22
	:::

Since it failed mounting, this patch will help you. Although the patch
will fix one bug, there still may exist another problem.

http://marc.info/?l=linux-cifs&m=131345112022031&w=2


J. R. Okajima
