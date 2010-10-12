Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab0JLWLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:11:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43969 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab0JLWLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:11:12 -0400
Message-ID: <4CB4DCDE.9050905@zytor.com>
Date: Tue, 12 Oct 2010 15:10:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/4] memblock related fixes for -tip
References: <4CAA4DC1.6000104@kernel.org> <4CB4ABE2.3010300@goop.org> <4CB4CF4D.5020706@kernel.org> <4CB4D660.3020105@zytor.com> <4CB4DABA.1030008@kernel.org>
In-Reply-To: <4CB4DABA.1030008@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2010 03:01 PM, Yinghai Lu wrote:
> On 10/12/2010 02:42 PM, H. Peter Anvin wrote:
>> On 10/12/2010 02:12 PM, Yinghai Lu wrote:
>>>
>>> please use 
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-2.6-yinghai.git memblock
>>>
>>> to find which commit cause xen broken.
>>>
>>> two xen related patch are folded into first converting commit.
>>>
>>
>> Do you have an incremental patch for this?
> 
> you have put those two patches in tip/memblock already.
> 
> rebasing the tree, so Jeremy could bisect the tree to root cause why xen still doesn't.
> 

Oh I see, this is for debugging, and not as a fix.

	-hpa
