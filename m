Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0JEHiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:38:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab0JEHiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:38:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Zs4Gh7iwRlpMs5DctzPIdKEnLONqe3kkGJvwIEFT5gVxUzS/mVOX2CTxeIagmlDS+a
         Bzs8w/861AuMD5AuQgMho2VQcYwejgATKAjBRHJBL9lho7S4g+sw681G/WC1X1KHctVt
         vJ5YILXst3wFdjn9PUWYFvvG88aVLcevoVVTw=
MIME-Version: 1.0
In-Reply-To: <20101005161220.0bef433f.sfr@canb.auug.org.au>
References: <20101005161220.0bef433f.sfr@canb.auug.org.au>
Date: Tue, 5 Oct 2010 09:38:49 +0200
Message-ID: <AANLkTikF+-0ybP3RMA-7wr8DMit6At=G1W7oB0UO4Mvz@mail.gmail.com>
Subject: Re: linux-next: Tree for October 5
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Valdis.Kletnieks@vt.edu, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see the same build errors as in -next 2010-10-04

Also, I saw this
/home/test/linux-2.6/include/linux/fs.h:1274:20: warning: function
declaration isn't a prototype
/home/test/linux-2.6/include/linux/fs.h:1278:20: warning: function
declaration isn't a prototype

It was fixed in -mmotm by Valdis Kletnieks.


-- 
Slawa!
N.P.S.

Les fleurs du mal unfold
Comme les fleurs du mal
Dark demons of my soul
Un amour fatal
