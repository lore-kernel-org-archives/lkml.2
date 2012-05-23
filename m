Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780Ab2EWR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:57:23 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52638 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760661Ab2EWR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:57:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120523174844.GA3373@gmail.com>
References: <20120523113432.GA12142@gmail.com> <CA+55aFzCDKK56CRXWXrPPtok84KJY4BbORcT3GfEH8xmOfgP6g@mail.gmail.com>
 <4FBD1AC8.7020602@zytor.com> <20120523174844.GA3373@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 10:57:00 -0700
X-Google-Sender-Auth: DkHhZMWhX-C6gEACryQDNvWoOno
Message-ID: <CA+55aFwpja0NxBser2EXjoMRTf0xobcCURqGtqyRXi4daPW0gg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent fixes for v3.5
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Also, we can rebase the whole branch and get rid of this one and
> of the merge commit it has.

I took it, but it was really unnecessary.

There were printk() patches in the queue and being discussed that
needed this, but I wouldn't have pulled the end result if they hadn't
been fixed.

                 Linus
