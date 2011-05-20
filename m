Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456Ab1ETJTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:19:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:45133 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933700Ab1ETJTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:19:40 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/O3oVfkXfOemBaGxBh4ZQA3CFExW6xWmhW6MD3mB
	dRpkckZY3aAdyn
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "richard -rw- weinberger" <richard.weinberger@gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
Date: Fri, 20 May 2011 11:19:35 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.6; KDE/4.6.3; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
References: <201105191526.31904.toralf.foerster@gmx.de> <201105201058.20355.toralf.foerster@gmx.de> <BANLkTim6yqMipB37Q=OJg=aC89vumCVewg@mail.gmail.com>
In-Reply-To: <BANLkTim6yqMipB37Q=OJg=aC89vumCVewg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105201119.36155.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger wrote at 11:02:35

> I hope it's _exactly_ the same result. vmlinux and linux are hard linked...
tfoerste@n22 ~/devel/linux-2.6 $ ls -lid vmlinux linux 
2034205 -rwxr-xr-x 2 tfoerste users 35624874 May 20 09:28 linux
2034205 -rwxr-xr-x 2 tfoerste users 35624874 May 20 09:28 vmlinux


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
