Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2BDKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 05:09:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57065 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750998Ab2BDKJ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 05:09:58 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/jbngBYyPjnhENNGyoqSVvADIcnolGdG+qhYZ4RU
	3NxqZS05Ji239Z
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: swap storm since kernel 3.2.x
Date: Sat, 4 Feb 2012 11:09:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.3; KDE/4.8.0; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201202041109.53003.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Within the last few weeks I'm observing sometimes a swap storm at my ThinkPad 
while compiling/installing new packages at my Gentoo Linux - the load is often 
something like :

Load avg: 13.6, 20.6, 20.9

I'm wondering whether this is related to kernel 3.2.x /Gentoo specific or 
related to my system only.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
