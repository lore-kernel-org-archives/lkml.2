Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2GPBwC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 21:52:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59495 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GPBwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 21:52:01 -0400
Message-ID: <500373B4.6020704@gmail.com>
Date: Sun, 15 Jul 2012 19:51:48 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com> <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com> <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com> <20120712161359.GJ7298@redhat.com>
In-Reply-To: <20120712161359.GJ7298@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/12/12 10:13 AM, Gleb Natapov wrote:
> On Thu, Jul 12, 2012 at 07:06:35PM +0300, Gleb Natapov wrote:
>>>
>>> So, is the idea of your patch to not enable the PEBS in guest mode?
>>>
>> Yes, the idea of my patch is to disable PEBS and the guest entry.
>>
> BTW what is you host cpu? My patch works only for those that have global
> control register to disable PMU events, but that should cover most of
> moder cpus.

So far all tests have been done on an HP with 2 Nehalem processors 
(E5540); I have another server with a couple of Westmere's (E5620) that 
I will test at some point.

David
