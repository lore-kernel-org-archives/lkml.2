Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760726Ab0GWQn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 12:43:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47248 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759583Ab0GWQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 12:43:24 -0400
Message-ID: <4C49C66A.3000002@kernel.org>
Date: Fri, 23 Jul 2010 09:42:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: fweisbec@gmail.com, peterz@infradead.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: perf swallows all NMIs when registered with a user
References: <20100722215136.GA23517@redhat.com> <4C48CD0D.5020201@kernel.org> <20100723125505.GQ7330@redhat.com>
In-Reply-To: <20100723125505.GQ7330@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C49C698.0037,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2010 05:55 AM, Don Zickus wrote:
> On Thu, Jul 22, 2010 at 03:58:21PM -0700, Yinghai Lu wrote:
>> cool, with your patch and following patch i can use nmi button now with CONFIG_LOCKUP_DETECTOR defined
>>
>> [PATCH] x86,nmi: move unknown_nmi_panic to traps.c
>>
>> So we use it even LOCKUP_DETECTOR is defined.
>>
>> need Don's patch...
> 
> Thanks for the feedback Yinghai!
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> With regards to your patch, I am still a little uncomfortable with it, as
> it seems to be redundant with what is used in unknown_nmi_error() and the
> panic_on_unrecovered_nmi flag.  I agree that keeping the familiar flag
> 'unknown_nmi_panic' is needed.  But I was still wondering if wrapping it
> around 'panic_on_unrecovered_nmi' would be simpler and less code.

how about the one in sysctl?

Thanks

Yinghai
