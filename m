Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2ICFgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:36:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56413 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2ICFgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:36:39 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-12-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-12-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:36:38 +0300
X-Google-Sender-Auth: tvZnrg7q4FoWeCAl65pQsw08h5I
Message-ID: <CAOJsxLHhU2n9Sqtqfb7yv+SfJWQyjFPP0uNVrFynurA04_09gw@mail.gmail.com>
Subject: Re: [PATCH -v2 11/13] x86/mm: calculate_table_space_size based on
 memory ranges that are being mapped
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> From: Jacob Shin <jacob.shin@amd.com>
>
> Current logic finds enough space for direct mapping page tables from 0
> to end. Instead, we only need to find enough space to cover mr[0].start
> to mr[nr_range].end -- the range that is actually being mapped by
> init_memory_mapping()
>
> This patch also reportedly fixes suspend/resume issue reported in:
>
> https://lkml.org/lkml/2012/8/11/83
>
> -v2: update with calculate_table_space_size()
>      clear max_pfn_mapped before init_all_memory_mapping to get right value
>                                           -Yinghai Lu
>
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>

Yinghai's sign-off is missing.

Reviewed-by: Pekka Enberg <penberg@kernel.org>
