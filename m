Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab2LCDBL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 22:01:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:41182 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2LCDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 22:01:10 -0500
X-IronPort-AV: E=Sophos;i="4.83,359,1352044800"; 
   d="scan'208";a="6318165"
Message-ID: <50BC15E1.8060806@cn.fujitsu.com>
Date: Mon, 03 Dec 2012 11:00:49 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, bcrl@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, hughd@google.com, cl@linux.com, mgorman@suse.de,
        minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121129153930.477e9709.akpm@linux-foundation.org> <50B82B0D.8010206@cn.fujitsu.com> <20121129215749.acfd872a.akpm@linux-foundation.org> <50B859C6.3020707@cn.fujitsu.com> <20121129235502.05223586.akpm@linux-foundation.org> <50B88A8A.9020802@cn.fujitsu.com> <20121130024755.b5dae17e.akpm@linux-foundation.org>
In-Reply-To: <20121130024755.b5dae17e.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 11:00:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 11:00:34,
	Serialize complete at 2012/12/03 11:00:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/30/2012 06:47 PM, Andrew Morton wrote:
> On Fri, 30 Nov 2012 18:29:30 +0800 Lin Feng <linfeng@cn.fujitsu.com> wrote:
> 
>>> add a new library function which callers can use before (or after?)
>>> calling get_user_pages[_fast]().
>> Sorry, I'm not quite understand what "library function" function means..
>> Does it means a function aids get_user_pages() or totally wraps/replaces 
>> get_user_pages(), or none of above?
> 
> "library function" is terminology for a general facility which
> the core kernel makes available to other parts of the kernel. 
> get_user_pages() is a library function, as are the functions in lib/,
> etc.  "grep EXPORT_SYMBOL ./*/*.c"
hi Andrew,

Thanks for your explanation and sorry for my ignorant question :)
As Mel said Still I can't find a way to make every guy happy..

Thanks,
linfeng

> 
> 
> 
