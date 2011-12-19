Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LSSuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:50:00 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40813 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab1LSSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:49:57 -0500
Date: Mon, 19 Dec 2011 10:49:53 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
In-Reply-To: <20111219184047.GA5637@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1112191049370.19949@chino.kir.corp.google.com>
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20111219184047.GA5637@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Dec 2011, Andi Kleen wrote:

> It would be better to have PageTransCompound be a dummy (always 0) 
> for !CONFIG_TRANSPARENT_HUGEPAGE

It already is.

> and KPF_THP always defined.
> This would keep ifdefery in the headers.
> 

Agreed.
