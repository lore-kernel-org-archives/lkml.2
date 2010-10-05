Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0JEIui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:50:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0JEIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:50:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for October 5
Date: Tue, 5 Oct 2010 10:50:26 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Valdis.Kletnieks@vt.edu
References: <20101005161220.0bef433f.sfr@canb.auug.org.au> <AANLkTikF+-0ybP3RMA-7wr8DMit6At=G1W7oB0UO4Mvz@mail.gmail.com> <20101005194232.de733b2b.sfr@canb.auug.org.au>
In-Reply-To: <20101005194232.de733b2b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051050.26543.arnd@arndb.de>
X-Provags-ID: V02:K0:CEXJQjZ1Mx4FlnvMu5A0f/KPt7LZnNXJVqdSdLel2hS
 wU98z39n6Q33bp1D+i+p+StyL9uffjKa8kpFyjxit0SCBAxVyC
 nILP8xmk9J2eA3IuQ0wFaWNxdhBnW5zO+79IgVy8dGsCR6z6rE
 cJSZz8Vy5vUDKPIymQivvFSkgmJO4KrG/MepWDR7HL9kx/Su4F
 MXY+Bb+rabg0hvSk21mPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 October 2010, Stephen Rothwell wrote:
> Hi,
> 
> On Tue, 5 Oct 2010 09:38:49 +0200 Zimny Lech <napohybelskurwysynom2010@gmail.com> wrote:
> >
> > Also, I saw this
> > /home/test/linux-2.6/include/linux/fs.h:1274:20: warning: function
> > declaration isn't a prototype
> > /home/test/linux-2.6/include/linux/fs.h:1278:20: warning: function
> > declaration isn't a prototype
> > 
> > It was fixed in -mmotm by Valdis Kletnieks.
> 
> Yeah, it was fixed in linux-next, but rebroken by a rebase of the bkl-vfs
> tree since yesterday.

Ok, fixed it again now. Sorry for messing this up twice.

	Arnd
