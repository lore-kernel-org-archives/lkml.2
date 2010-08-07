Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0HGBWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 21:22:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab0HGBWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 21:22:19 -0400
Message-ID: <4C5CB52A.9080102@zytor.com>
Date: Fri, 06 Aug 2010 18:21:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, tvrtko.ursulin@sophos.com,
        hilld@binarystorm.net, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, apic: Map the local apic when parsing the
 MP table.
References: <m1eiee86jg.fsf_-_@fess.ebiederm.org>	<tip-5989cd6a1cbf86587edcc856791f960978087311@git.kernel.org>	<4C5CA3E4.1080908@kernel.org> <4C5CA5AC.3060608@zytor.com> <m1d3tvtekq.fsf@fess.ebiederm.org>
In-Reply-To: <m1d3tvtekq.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 06:08 PM, Eric W. Biederman wrote:
>>
>> I'm not sure the above is decipherable.  Please provide an incremental
>> patch with a more detailed description.
> 
> YH was saying I overoptimized, and it looks like he is right,
> although there are only one or two machines in existence that
> are likely to be affected.
> 
> Untested patch to remove the cleverness below.  It it boots all
> is well.
> 

This makes sense to me.  Yinghai, do you have a system that is actually
affected, and if so, could you test this patch?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

