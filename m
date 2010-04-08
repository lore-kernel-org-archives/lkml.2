Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933009Ab0DHR5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:57:14 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:65037 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab0DHR5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:57:02 -0400
Message-ID: <4BBE180C.80901@oracle.com>
Date: Thu, 08 Apr 2010 10:53:16 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Peter Jones <pjones@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [LKML] Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region()
 to find_ibft_region()
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org> <20100408161210.GA13382@phenom.dumpdata.com> <alpine.LFD.2.00.1004081027140.3558@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004081027140.3558@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BBE1873.009C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2010 10:28 AM, Linus Torvalds wrote:
> 
> 
> On Thu, 8 Apr 2010, Konrad Rzeszutek Wilk wrote:
>>
>> Oh, I am definitely ACK-ing. Sorry about not explicitly stating that.
>> The developer is Yinghai Lu, I am the co-maintainer of the iBFT driver.
>>
>> Linus, would you like me to modify the commit so that it has 'Acked-by:'
>> by me in the git tree?
> 
> No, no, a sign-off is already an ack, and is "stronger" than an ack, since 
> it actually also means that you send it onwards. A patch that you don't 
> like you would obviously never sign off on either.
> 
> I was more looking for comments from other people who know what the heck 
> that early reservation system does.

the patched is in mainline already in mainline through tip path by HPA.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=042be38e6106ed70b42d096ab4a1ed4187e510e6

Thanks

Yinghai
