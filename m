Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab1KVIKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 03:10:33 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38955 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1KVIKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 03:10:32 -0500
MIME-Version: 1.0
In-Reply-To: <201108160554.p7G5soeq002083@demeter2.kernel.org>
References: <bug-41132-5003@https.bugzilla.kernel.org/>
	<201108160554.p7G5soeq002083@demeter2.kernel.org>
Date: Tue, 22 Nov 2011 06:10:31 -0200
X-Google-Sender-Auth: 4OjT1YzLLadvxRv5rbfVmk3dcVs
Message-ID: <CAOtrxKP-0TfJa8dS8_uW195WO13YCy-UyaZfweYD4Tv_1gAmKQ@mail.gmail.com>
Subject: Re: [Bug 41132] [BISECTED][REGRESSION] Regression with the IRQ
 subsystem introduced in 2.6.39 (and present in the 3.x version)
From: =?UTF-8?Q?Rog=C3=A9rio_Brito?= <rbrito@ime.usp.br>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, drivers_pci@kernel-bugs.osdl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there.

Now that, at least part of kernel.org is up, I would appreciate it
more people could help with debugging something that I reported to
bugzilla in july of this year, a regression (bisected) that led to a
bad commit of Thomas in the 2.6.39 cycle as the first bad one.

Bugzilla has more information on the issue, but as it seems to be
down, I can, of course, summarize what I found. And, unfortunately,
the problem still occurs with a recent pull of Linus tree up to
v3.2-rc2-43-gaa1b052.

Below is the link to my first message that was archived:

> --- Comment #3 from Rogério Brito <rbrito@ime.usp.br>  2011-08-16 05:54:47 ---
> Add note that this bug was first reported on 2011-07-04
>
>    https://lkml.org/lkml/2011/7/24/54
>
> As stated on that e-mail, I am willing to perform any tests to help fix this
> bug. Just ask me and I will do my best to give you copious amounts of data.


Thanks,
Rogério Brito.

-- 
Rogério Brito : rbrito@{ime.usp.br,gmail.com} : GPG key 4096R/BCFCAAAA
http://rb.doesntexist.org : Packages for LaTeX : algorithms.berlios.de
DebianQA: http://qa.debian.org/developer.php?login=rbrito%40ime.usp.br
