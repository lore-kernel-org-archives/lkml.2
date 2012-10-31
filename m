Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733Ab2JaUOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:14:12 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42534 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758264Ab2JaUOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:14:09 -0400
MIME-Version: 1.0
In-Reply-To: <20121031201227.GF1271@dhcp22.suse.cz>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
	<1351712650-23709-2-git-send-email-tj@kernel.org>
	<20121031201227.GF1271@dhcp22.suse.cz>
Date: Wed, 31 Oct 2012 13:14:07 -0700
X-Google-Sender-Auth: 5WwqXNFg1KxpVSC0UPGZojgaMLY
Message-ID: <CAOS58YOHjLyKFeah+h+qOrAWvfi1O5eL7m-AMbqAdcP=EOFb6g@mail.gmail.com>
Subject: Re: [PATCH 1/8] cgroup: kill cgroup_subsys->__DEPRECATED_clear_css_refs
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Wed, Oct 31, 2012 at 1:12 PM, Michal Hocko <mhocko@suse.cz> wrote:
> And sorry for being to annoying about this WARN_ON_ONCE but I really
> don't see any reason for it. pre_destroy can still happen and now it is
> even reduced to a reasonable condition (somebody shown up). So I would
> put it out of way as it doesn't give us anything and as I've already
> mentioned one can trigger it really easily.

It was there before and goes away in several commits.  I have to
explain all that to remove it in this patch.  Why do that when the
whole thing is just gonna disappear anyway?

Thanks.

-- 
tejun
