Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab2BNHW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:22:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52843 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab2BNHW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120214121515.34281b73.kamezawa.hiroyu@jp.fujitsu.com>
References: <20120214120414.025625c2.kamezawa.hiroyu@jp.fujitsu.com> <20120214121515.34281b73.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Feb 2012 23:22:37 -0800
Message-ID: <CAHH2K0aWdLM523b9VnqJuW_c_rvR7-ZCDEGmzJWfo6g5pj7Cbw@mail.gmail.com>
Subject: Re: [PATCH 5/6 v4] memcg: remove PCG_FILE_MAPPED
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 7:15 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From 96407a510d5212179a4768f28591b35d5c17d403 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Thu, 2 Feb 2012 15:02:18 +0900
> Subject: [PATCH 5/6] memcg: remove PCG_FILE_MAPPED
>
> with new lock scheme for updating memcg's page stat, we don't need
> a flag PCG_FILE_MAPPED which was duplicated information of page_mapped().
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks!

Acked-by: Greg Thelen <gthelen@google.com>
