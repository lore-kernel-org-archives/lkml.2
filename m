Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab2IKQYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:24:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab2IKQYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:24:17 -0400
Message-ID: <504F65A7.3040203@redhat.com>
Date: Tue, 11 Sep 2012 12:24:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Youquan Song <youquan.song@linux.intel.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Len Brown <len.brown@intel.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        ShuoX Liu <shuox.liu@intel.com>, youquan.song@intel.com
Subject: Re: KS/Plumbers: c-state governor BOF
References: <5037B36A.8000209@redhat.com> <20120912024342.GA23544@linux-youquan.bj.intel.com> <504F5A18.8080701@redhat.com> <20120912041547.GB23544@linux-youquan.bj.intel.com>
In-Reply-To: <20120912041547.GB23544@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 12:15 AM, Youquan Song wrote:
>> Your patches could make a lot of sense when integrated with my
>> patches:
>>
>> http://people.redhat.com/riel/cstate/
>> However, we should probably get the tracepoint upstream first,
>> so we can know for sure :)
>
> I can not access the patches at this directory. Can you send it to me?
> I will look at your patches and then integrated with my patches to look
> what will happen tomorrow.

Argh, fixed!

> Do you have test case share? or ideas how to show the benefit.
>
> I have done many test for my pathes. It show some benefit big or small
> in various cases, but there is no negative effect showed at least.
>
> I have two onviced test cases to show the great benefit
> 1.  turbostat v1 (before 3.5)
> 2. I write the simple test application which also show greate benefit.
> running it by #./idle_predict -l 8
>
>
> I write a simple application using usleep which it is clear to the
> repeat mode prediction failure will greatly effect the application with
> such repeat pattern.

Your test looks exactly like the kind of thing that could benefit
from my changes to the menu governor :)

-- 
All rights reversed
