Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0LQTjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:39:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41646 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab0LQTjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:39:32 -0500
Message-ID: <4D0BBC55.4010207@zytor.com>
Date: Fri, 17 Dec 2010 11:39:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <20101217170146.GC9568@redhat.com> <4D0BA45A.7020402@zytor.com> <20101217180242.GB12425@redhat.com> <4D0BAA24.3080801@kernel.org>
In-Reply-To: <4D0BAA24.3080801@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 10:21 AM, Yinghai Lu wrote:
>>>
>>> Do we have actual testing for how high the 64-bit kernel will load?
>>
>> I will do some experiments on my box today and let you know.
> 
> if bzImage is used, it is 896M.
> 

Why?  896 MiB is a 32-bit kernel limitation which doesn't have anything
to do with the bzImage format.

So unless there is something going on here, I suspect you're just plain
flat wrong.

	-hpa
