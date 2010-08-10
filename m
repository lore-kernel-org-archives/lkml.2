Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0HJTNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:13:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39579 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932358Ab0HJTNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:13:11 -0400
MIME-Version: 1.0
In-Reply-To: <201008102050.12558.arnd@arndb.de>
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com> 
	<4C617C94.5010808@tilera.com> <201008102050.12558.arnd@arndb.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Aug 2010 12:12:41 -0700
Message-ID: <AANLkTi=0nx-HO7Pyun6OCygpjcwP-1aZ+U6XjxEiz_eR@mail.gmail.com>
Subject: Re: [GIT] writable_limits for 2.6.36
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 11:50 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> Right. The writable_rlimits syscall should just go after wait4 at 262.

.. and in the meantime I added the notify tree too, so now the
x86(-64) numbers also clashed.

So I just moved the prlimit64() system call, both on x86[-64] and in
asm-generic/unistd.h

Pushed out. Guys, please verify that it looks ok.

                    Linus
