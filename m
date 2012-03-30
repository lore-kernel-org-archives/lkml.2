Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761130Ab2C3RsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:48:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50046 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2C3Rry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:47:54 -0400
MIME-Version: 1.0
In-Reply-To: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
References: <1333129114-22117-1-git-send-email-andi@firstfloor.org>
Date: Fri, 30 Mar 2012 13:47:53 -0400
Message-ID: <CA+5PVA6h3+493VrZg1OyjkjP9f77CLC9PP9PuJOGMYNLM9Lq4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: fix build for rbtree.c change
From: Josh Boyer <jwboyer@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 1:38 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> rbtree.c in the main tree now includes linux/export.h, so this file
> needs a stub too. This makes perf build again in mainline.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commit;h=2c86bf172e550b4bf089ac7f0de3f6370e243842

Apparently 'perf-urgent-for-linus' isn't as urgent as it sounds?

josh
