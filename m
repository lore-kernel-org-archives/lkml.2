Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab0HKCj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:39:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab0HKCj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:39:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT] writable_limits for 2.6.36
Date: Wed, 11 Aug 2010 04:39:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <4C5D4E50.5050105@suse.cz> <201008102050.12558.arnd@arndb.de> <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com>
In-Reply-To: <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008110439.08421.arnd@arndb.de>
X-Provags-ID: V02:K0:ynly5ExDUomiTn8O390zuE8n3IKeRP54RbKsUr13ymC
 otxg0qkQslnkxD74iVnC5JWxwqHGn3cDPvo5S+RG0kRLokfpC2
 YK1Fgrzzpb0o0A5h+eOnArX4l7fivBwR0CmwPP6LysLzqTmJpA
 Dn4CbtmTQKoo0H7LDQkgZfxQMEGJkEzhkdp1GJ/zwM3z6MYODa
 iaHdSDFFtGrFa/lhuQKIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 August 2010, Linus Torvalds wrote:
> On Tue, Aug 10, 2010 at 11:50 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> So I just moved the prlimit64() system call, both on x86[-64] and in
> asm-generic/unistd.h
> 
> Pushed out. Guys, please verify that it looks ok.

Looks good, thanks!

	Arnd
