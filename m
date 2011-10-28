Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1J1GMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:12:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60016 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab1J1GMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:12:41 -0400
Message-ID: <4EAA4799.1020505@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 14:11:37 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: FNST
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110322 Red Hat/3.1.9-3.el6_0 Thunderbird/3.1.9
MIME-Version: 1.0
To: Bob Liu <lliubbo@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [possible deadlock][3.1.0-g138c4ae] possible circular locking
 dependency detected
References: <4EAA2492.3020907@cn.fujitsu.com>	<CAA_GA1eGt-Xu1wQ-g0v+J7CD4OEAU1nm1Eviww1+mOKjYWEcMg@mail.gmail.com>	<4EAA4263.2090809@cn.fujitsu.com> <CAA_GA1cKK45Z=YFUHRi-LUuhWpcs9ruW9xom_6LRmqhRNao+hQ@mail.gmail.com>
In-Reply-To: <CAA_GA1cKK45Z=YFUHRi-LUuhWpcs9ruW9xom_6LRmqhRNao+hQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 14:10:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 14:10:43,
	Serialize complete at 2011-10-28 14:10:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 02:02 PM, Bob Liu wrote:


>>
>>
>> Oh, it looks like can fix this bug, but I also can't reproduce it whether with or without this patch.
>>
> 
> Make sure CONFIG_DEBUG_LOCK_ALLOC was set.
> 


Yeah, certainly, if not, the dmesg can't appear anyway.
