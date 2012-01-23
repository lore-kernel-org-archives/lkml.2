Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2AWKwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:52:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42045 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752770Ab2AWKwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:52:31 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19qgStgcJJq0UbrI3q1upzU/nh1f2zGa69rk4NbRs
	VfLJu78rTvYiLr
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: multi-media key "mute" no longer recognized
Date: Mon, 23 Jan 2012 11:52:24 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.1; KDE/4.7.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201231152.25344.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With kernel 3.1.10 I could mute my system by pressing the appropriate 
multimedia button either at my ThinkPad or at my external keyboard.
With 3.2.1 this doesn't work anymore although the button itself is recognized 
when pressed (checked with xev).

Now I'm wondering where to start to debug ?

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
