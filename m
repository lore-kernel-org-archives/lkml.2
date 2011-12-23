Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab1LWWwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 17:52:43 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58592 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1LWWwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 17:52:41 -0500
MIME-Version: 1.0
In-Reply-To: <4EF3F834.0@cn.fujitsu.com>
References: <4EF2EDA7.4010004@cn.fujitsu.com>
	<20111222152011.GA17084@google.com>
	<4EF3F834.0@cn.fujitsu.com>
Date: Fri, 23 Dec 2011 14:52:40 -0800
X-Google-Sender-Auth: iuE-hySmZT9RePXyfg5787DYCNw
Message-ID: <CAOS58YMffJ4uH02H0TH_DmhtjQOVgz2_u_6HJqsGnR6PQ3ZGzw@mail.gmail.com>
Subject: Re: [PATCH] cgroup: move a check to parse_cgroupfs_options()
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 7:40 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> And where did this one go?
>
> The other one I removed sets opts->new_root to NULL, and this one detects
> the NULL ptr:
>
> if (!opts->subsys_bits && !opts->none)
>        return NULL;
> ...
> opts->new_root = NULL;
> ...
> if (!opts->new_root)
>        return -EINVAL;
>
> shortcut to:
>
> if (!opts->subsys_bits && !opts->none)
>        return -EINVAL;

Thanks for the explanation. Maybe explaining it briefly in the commit
message would be nice?

-- 
tejun
