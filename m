Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1LURBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 12:01:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41920 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1LURBq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 12:01:46 -0500
MIME-Version: 1.0
In-Reply-To: <20111221111143.346150952@chello.nl>
References: <20111221105739.798864333@chello.nl> <20111221111143.346150952@chello.nl>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 21 Dec 2011 12:01:23 -0500
X-Google-Sender-Auth: gBZTEG9z_3qlejIAhteD5QADs7U
Message-ID: <CAMjpGUcCkC_qhEWZSKZyF-6HSdqFx3F6=SS-oMmHBQHAELa=Lw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/7] arch, early_printk: Consolidate early_printk() implementations
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  arch/blackfin/kernel/early_printk.c   |    2 -

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
