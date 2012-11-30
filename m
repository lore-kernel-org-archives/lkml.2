Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2K3KsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:48:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2K3KsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:48:05 -0500
Date: Fri, 30 Nov 2012 02:47:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, bcrl@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, hughd@google.com, cl@linux.com, mgorman@suse.de,
        minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
Message-Id: <20121130024755.b5dae17e.akpm@linux-foundation.org>
In-Reply-To: <50B88A8A.9020802@cn.fujitsu.com>
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com>
	<20121129153930.477e9709.akpm@linux-foundation.org>
	<50B82B0D.8010206@cn.fujitsu.com>
	<20121129215749.acfd872a.akpm@linux-foundation.org>
	<50B859C6.3020707@cn.fujitsu.com>
	<20121129235502.05223586.akpm@linux-foundation.org>
	<50B88A8A.9020802@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012 18:29:30 +0800 Lin Feng <linfeng@cn.fujitsu.com> wrote:

> > add a new library function which callers can use before (or after?)
> > calling get_user_pages[_fast]().
> Sorry, I'm not quite understand what "library function" function means..
> Does it means a function aids get_user_pages() or totally wraps/replaces 
> get_user_pages(), or none of above?

"library function" is terminology for a general facility which
the core kernel makes available to other parts of the kernel. 
get_user_pages() is a library function, as are the functions in lib/,
etc.  "grep EXPORT_SYMBOL ./*/*.c"


