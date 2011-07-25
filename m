Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1GYDIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:08:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39276 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab1GYDIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:08:19 -0400
From: Ben Gamari <bgamari.foss@gmail.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH v4 4/7] Reclaim invalidated page ASAP
In-Reply-To: <AANLkTikT_HNvuBR0J-2COgB54gquj2FineOjkzU+mt6_@mail.gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com> <0724024711222476a0c8deadb5b366265b8e5824.1291568905.git.minchan.kim@gmail.com> <20101208170504.1750.A69D9226@jp.fujitsu.com> <AANLkTikG1EAMm8yPvBVUXjFz1Bu9m+vfwH3TRPDzS9mq@mail.gmail.com> <87oc8wa063.fsf@gmail.com> <AANLkTin642NFLMubtCQhSVUNLzfdk5ajz-RWe2zT+Lw6@mail.gmail.com> <20101213153105.GA2344@barrios-desktop> <87lj3t30a9.fsf@gmail.com> <AANLkTikT_HNvuBR0J-2COgB54gquj2FineOjkzU+mt6_@mail.gmail.com>
User-Agent: Notmuch/0.6.1-76-g1635f57 (http://notmuchmail.org) Emacs/23.2.1 (x86_64-pc-linux-gnu)
Date: Sun, 24 Jul 2011 23:08:10 -0400
Message-ID: <87vcurrrad.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 11:36:12 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> Hi Ben,
> 
> [snipped]

What exactly happened to this set? It seems it dropped off my radar and
otherwise never was merged. Was it not tested enough, the benefit not
great enough, or did it simply slip through the cracks?

Cheers,

- Ben
