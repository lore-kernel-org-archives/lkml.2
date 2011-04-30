Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab1D3VJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 17:09:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:35452 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756429Ab1D3VJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 17:09:33 -0400
Content-Type: text/plain; charset="utf-8"
Date: Sat, 30 Apr 2011 23:09:30 +0200
From: "Cedric Sodhi" <ManDay@gmx.net>
Message-ID: <20110430210930.268900@gmx.net>
MIME-Version: 1.0
Subject: Status of vgaswitcheroo - Devastating!
To: linux-kernel@vger.kernel.org
X-Authenticated: #19862253
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+m1Cx1cSOm3CAyodiZyEbskrcHTTGi7zpA+Jg/x5
 BYdKRV/OgWdn+yvTZQNboFQJTbINYVRetnSg== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: sk2PeUgbf2IsBrp7Q21omrV4dWxlcxZj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear list,

for more and more people it becomes either very difficult or, like for me, practically impossible to boot on a Dual-Card setup.

If you look arround the Ubuntu forums and many many other communties you will find that most, if not all users with such setups experience great problems, many of them receive blank screens, kernel panics, black screens, etc.

I for my part have a HP Touchsmart tm2 laptop with the Intel/ATI kind of setup and thought the commit message in GIT says that this is the exact type that is meant to be supported, I find myself unable to boot into my system.

Some live distros work (I've made the best experience with Mint 10 x64), but even for them the results are kind of random. In some cases the system boots, in some the screen remains blank or black, sometimes closing the screen and opening it again helps, sometimes I can reboot with Ctrl-Alt-Del, sometimes through SysReq, it's rather random.

To my consternation, the one and only commit related to switcheroo is over a year old and I have found no indication whatsoever that this is being further addressed.

I would very much dislike having to use Windows in order to use this PC, just because I can't even get it to boot.

I partially blame HPs atrocious BIOS for this desaster, so I really don't know how far this can possibly be resolved, but I hope it can, because according to the commit message it was at least possible on a different computer with a similar setup.

Please help!
-- 
NEU: FreePhone - kostenlos mobil telefonieren und surfen!			
Jetzt informieren: http://www.gmx.net/de/go/freephone
