Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0JYA6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 20:58:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0JYA6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 20:58:53 -0400
Message-ID: <4CC4D681.8020809@cn.fujitsu.com>
Date: Mon, 25 Oct 2010 08:59:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "akpm >> Andrew Morton" <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/7] cgroups: Allow to bind a subsystem to a cgroup hierarchy
References: <4CC146A4.9090505@cn.fujitsu.com>	 <4CC146D4.7030009@cn.fujitsu.com> <1287751631.15336.33.camel@twins>
In-Reply-To: <1287751631.15336.33.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2010-10-22 at 16:09 +0800, Li Zefan wrote:
>> For example, we can't decide a cgroup's cpuset.mems and
>> cpuset.cpus automatically, so cpuset is not bindable. 
> 
> You mean to say that you cannot add cpuset to an existing hierarchy
> right? Not that you cannot add perf/cpuacct to an existing cpuset
> hierarchy?
> 

Exactly. You can see from the example. 
