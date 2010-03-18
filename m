Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0CRGfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:35:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61074 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0CRGfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:35:38 -0400
Message-ID: <4BA1C9EC.2030801@cn.fujitsu.com>
Date: Thu, 18 Mar 2010 14:36:28 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: fweisbec@gmail.com, sparclinux@vger.kernel.org, tj@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] percpu misaligned allocation
References: <20100318044930.GC5045@nowhere>	<20100317.232648.59697287.davem@davemloft.net> <20100317.232834.115948373.davem@davemloft.net>
In-Reply-To: <20100317.232834.115948373.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I can't even find kernel/trace/trace_event_perf.c, what tree

It's kernel/trace/trace_event_profile.c in linus' tree.

> are you using?

must be Ingo's -tip tree, or his own tree which is based on -tip tree.
