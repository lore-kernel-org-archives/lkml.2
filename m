Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0HYHpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:45:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HYHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:45:21 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Haicheng Li <haicheng.li@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
        "ak\@linux.intel.com" <ak@linux.intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>
Subject: Re: [BUGFIX][PATCH 1/2] x86, mem: separate x86_64 vmalloc_sync_all() into separate functions
References: <4C6E4ECD.1090607@linux.intel.com>
Date: Wed, 25 Aug 2010 09:45:13 +0200
In-Reply-To: <4C6E4ECD.1090607@linux.intel.com> (Haicheng Li's message of
	"Fri, 20 Aug 2010 17:45:49 +0800")
Message-ID: <87r5hni19y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haicheng Li <haicheng.li@linux.intel.com> writes:

> hello,
>
> Resend these two patches for bug fixing:
>
> The bug is that when memory hotplug-adding happens for a large enough area that a new PGD entry is
> needed for the direct mapping, the PGDs of other processes would not get updated. This leads to some
> CPUs oopsing when they have to access the unmapped areas, e.g. onlining CPUs on the new added node.

The patches look good to me. Can we please move forward with this?

Reviewed-by: Andi Kleen <ak@linux.intel.com>

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
