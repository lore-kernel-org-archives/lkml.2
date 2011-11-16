Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab1KPHMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 02:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385Ab1KPHMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 02:12:30 -0500
Message-ID: <4EC3624B.4080805@redhat.com>
Date: Wed, 16 Nov 2011 15:12:11 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Thunderbird/3.1.15
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org
Subject: Re: [Patch] tmpfs: add fallocate support
References: <1321346525-10187-1-git-send-email-amwang@redhat.com> <20111116101846.5b017d1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111116101846.5b017d1e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月16日 09:18, KAMEZAWA Hiroyuki 写道:
>
> Hmm.. Doesn't this duplicate shmem_getpage_gfp() ? Can't you split/share codes ?
>

Yeah, you are right... I will split the code.

Thanks for review.
