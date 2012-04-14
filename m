Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab2DNGfd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 02:35:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37220 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524Ab2DNGfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 02:35:32 -0400
MIME-Version: 1.0
In-Reply-To: <tip-ea01fa9f63aeff3ac918868217aa94adf76ddcc7@git.kernel.org>
References: <1334162178-17152-6-git-send-email-bp@amd64.org> <tip-ea01fa9f63aeff3ac918868217aa94adf76ddcc7@git.kernel.org>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sat, 14 Apr 2012 08:35:09 +0200
Message-ID: <CALxABCZ-gCZnRd1mZEN1WSdim6RgQUa1YMbNK7mNoMFTXgWJ3A@mail.gmail.com>
Subject: Re: [tip:perf/core] tools: Connect to the kernel build system
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, sam@ravnborg.org, tglx@linutronix.de, mmarek@suse.cz,
        borislav.petkov@amd.com
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 20:18, tip-bot for Borislav Petkov
<borislav.petkov@amd.com> wrote:
> Also, if you want to get what the possible targets are, simply calling
>
> $ make tools/
>
> should give you the short help.

Is "make tools" (without trailing slash) reserved for something?
If not, it might make sense to allow it also (to mean "make tools/").
