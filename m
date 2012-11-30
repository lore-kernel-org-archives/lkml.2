Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030707Ab2K3PY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:24:28 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:52965 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030658Ab2K3PY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:24:26 -0500
Date: Fri, 30 Nov 2012 16:24:21 +0100
From: Domenico Andreoli <cavokz@gmail.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, hughd@google.com,
        cl@linux.com, mgorman@suse.de, minchan@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
Message-ID: <20121130152421.GA19849@glitch>
Mail-Followup-To: Lin Feng <linfeng@cn.fujitsu.com>,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk, bcrl@kvack.org,
	kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, hughd@google.com,
	cl@linux.com, mgorman@suse.de, minchan@kernel.org,
	isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
	wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:54:58PM +0800, Lin Feng wrote:
> Hi all,

Hi Lin,

> We encounter a "Resource temporarily unavailable" fail while trying
> to offline a memory section in a movable zone. We found that there are 
> some pages can't be migrated. The offline operation fails in function 
> migrate_page_move_mapping() returning -EAGAIN till timeout because 
> the if assertion 'page_count(page) != 1' fails.

is this something that worked before? if yes (then it's a regression)
do you know with which kernel?

Thanks,
Domenico
