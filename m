Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099Ab0FSVS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 17:18:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56503 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab0FSVSY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 17:18:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?=C3=89ric_Piel?= <E.A.B.Piel@tudelft.nl>
Subject: Re: [Regression 2.6.35-rc1?] Sysrq works too well (no need of alt)
Date: Sat, 19 Jun 2010 23:16:32 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4C0E0E51.8050709@tudelft.nl>
In-Reply-To: <4C0E0E51.8050709@tudelft.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006192316.32360.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 08, 2010, Éric Piel wrote:
> Hello,
> I haven't investigated much yet, but I have the feeling that since
> 2.6.35-rc1 my "Print Screen/SysRq" key works only as SysRq: if I press
> it (normally assigned to take screenshot in gnome), nothing happens (no
> input event received in userspace) and no key on the keyboard works
> afterwards, until I press Alt. Actually the keys work, but behave as if
> the sysrq key was kept pressed (can be seen in dmesg, or by pressing "b").
> 
> Looking at the log, a potential culprit is commit
> 97f5f0cd8cd0a05449cbb77d1e6f02e026875802 (Input: implement SysRq as a
> separate input handler). Probably the logic of "have to press all the
> keys at the same time" changed to "have to press the keys one after each
> other". So pressing alt and later on pressing PrintScreen leads to a SysRq.
> 
> Does anybody else see this behaviour? Any suggestion on how to solve
> this bug? I'll try reverting the commit and report if it fixes the
> problem (the git revert fails so I've got to fix the conflict manually).

Is this still a problem with 2.6.35-rc3?

Rafael
