Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab1GRMOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 08:14:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57210 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1GRMOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 08:14:19 -0400
MIME-Version: 1.0
In-Reply-To: <1310987909-3129-1-git-send-email-amwang@redhat.com>
References: <1310987909-3129-1-git-send-email-amwang@redhat.com>
Date: Mon, 18 Jul 2011 15:14:18 +0300
X-Google-Sender-Auth: YHdshUm1N9g8FUt3aWjzkTCgPbA
Message-ID: <CAOJsxLHuqvVEKg84jmRW_yfLic9ytB8GzeAE4YWauxSWryHGzA@mail.gmail.com>
Subject: Re: [Patch] mm: make CONFIG_NUMA depend on CONFIG_SYSFS
From: Pekka Enberg <penberg@kernel.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 2:18 PM, Amerigo Wang <amwang@redhat.com> wrote:
> On ppc, we got this build error with randconfig:
>
> drivers/built-in.o:(.toc1+0xf90): undefined reference to `vmstat_text': 1 errors in 1 logs
>
> This is due to that it enabled CONFIG_NUMA but not CONFIG_SYSFS.
>
> And the user-space tool numactl depends on sysfs files too.
> So, I think it is very reasonable to make CONFIG_NUMA depend on CONFIG_SYSFS.

Is it? CONFIG_NUMA is useful even without userspace numactl tool, no?
