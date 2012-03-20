Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2CTAUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:20:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33409 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2CTAUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120319155342.GA5113@gmail.com>
References: <20120319155342.GA5113@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 19 Mar 2012 17:20:30 -0700
X-Google-Sender-Auth: ep9GlhsoYbXGprDSDVRMVLs0XfI
Message-ID: <CA+55aFy5h1_ybF-7D9Jy-DW-3V+O8LxTWzEwHKORA+bqECWtOA@mail.gmail.com>
Subject: Re: [GIT PULL] perf events changes for v3.4
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 8:53 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest perf-core-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-core-for-linus

This seems to be another pull request that really could have done with
some high-level overview of what the changes are for 3.4

               Linus
