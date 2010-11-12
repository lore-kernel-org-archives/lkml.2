Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab0KLUlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 15:41:15 -0500
Received: from smtp-out.google.com ([74.125.121.35]:51403 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab0KLUlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 15:41:10 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:references:date:message-id:user-agent:
	mime-version:content-type;
	b=vV8RLSprKGi7Ob3+nhYEnKBmTpKpX19GFjIgvpHL4iIiLSAxJB/H9+3W2eA6XR4oE
	kj7VsjRXLE88RRhjwZaaA==
From: Greg Thelen <gthelen@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] memcg: simplify mem_cgroup_dirty_info()
References: <1289294671-6865-1-git-send-email-gthelen@google.com>
	<1289294671-6865-6-git-send-email-gthelen@google.com>
	<20101112082150.GG9131@cmpxchg.org>
Date: Fri, 12 Nov 2010 12:40:42 -0800
Message-ID: <xr93hbfmxol1.fsf@ninji.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@cmpxchg.org> writes:

> On Tue, Nov 09, 2010 at 01:24:30AM -0800, Greg Thelen wrote:
>> Because mem_cgroup_page_stat() no longer returns negative numbers
>> to indicate failure, mem_cgroup_dirty_info() does not need to check
>> for such failures.
>
> This is simply not true at this point in time.  Patch ordering is not
> optional.

Thanks.  Patch order will be corrected.
