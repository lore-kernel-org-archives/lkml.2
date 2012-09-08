Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab2IHCIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:08:10 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54644 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760425Ab2IHCIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:08:07 -0400
X-IronPort-AV: E=Sophos;i="4.80,390,1344182400"; 
   d="scan'208";a="5805955"
Message-ID: <504AA86B.9040302@cn.fujitsu.com>
Date: Sat, 08 Sep 2012 10:07:39 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        open@kvack.org,
        "list@kvack.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: fix mmap overflow checking
References: <1346750580-11352-1-git-send-email-gaowanlong@cn.fujitsu.com> <CAHGf_=o8VzFSF3kGK92bKgeWPJ4qOQ_NhCzXO-J_Ge22M7M20g@mail.gmail.com> <504AA2F9.5060502@cn.fujitsu.com> <CAHGf_=rPYAU6X2eXqyBxHV=PtguBceK=n_C89dTDbUk54-+6ww@mail.gmail.com>
In-Reply-To: <CAHGf_=rPYAU6X2eXqyBxHV=PtguBceK=n_C89dTDbUk54-+6ww@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/08 10:07:38,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/08 10:07:39,
	Serialize complete at 2012/09/08 10:07:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 09:58 AM, KOSAKI Motohiro wrote:
>>> I've seen the exactly same patch from another fujitsu guys several
>>> month ago. and as I pointed
>>> out at that time, this line don't work when 32bit kernel + mmap2 syscall case.
>>>
>>> Please don't think do_mmap_pgoff() is for mmap(2) specific and read a
>>> past thread before resend
>>> a patch.
>>
>> So, what's your opinion about this bug? How to fix it in your mind?
> 
> Fix glibc instead of kernel.
> 

OK, I will send a patch to glibc community. Thank you.

Wanlong Gao

