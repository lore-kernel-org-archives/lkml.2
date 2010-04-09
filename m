Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0DIDUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 23:20:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753301Ab0DIDUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 23:20:43 -0400
Message-ID: <4BBE9D58.2010602@cn.fujitsu.com>
Date: Fri, 09 Apr 2010 11:22:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       stable@kernel.org
Subject: Re: [PATCH] fix cgroup procs documentation
References: <20100409121143.9610dc8f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100409121143.9610dc8f.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> 2.6.33's Documentation has the same wrong information. So, I CC'ed to stable.
> If people believe this information, they'll usr cgroup.procs file and will
> see cgroup doesn'w work as expected.
> The patch itself is against -mm.
> 
> ==
> Writing to cgroup.procs is not supported now.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  Documentation/cgroups/cgroups.txt |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: mmotm-temp/Documentation/cgroups/cgroups.txt
> ===================================================================
> --- mmotm-temp.orig/Documentation/cgroups/cgroups.txt
> +++ mmotm-temp/Documentation/cgroups/cgroups.txt
> @@ -235,8 +235,7 @@ containing the following files describin
>   - cgroup.procs: list of tgids in the cgroup.  This list is not
>     guaranteed to be sorted or free of duplicate tgids, and userspace
>     should sort/uniquify the list if this property is required.
> -   Writing a tgid into this file moves all threads with that tgid into
> -   this cgroup.
> +   This is a read-only file, now.

I think the better wording is "for now". :)

>   - notify_on_release flag: run the release agent on exit?
>   - release_agent: the path to use for release notifications (this file
>     exists in the top cgroup only)
> 
