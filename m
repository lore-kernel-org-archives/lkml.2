Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2GONAR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 09:00:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46952 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2GONAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 09:00:10 -0400
Message-ID: <5002BEE3.5060506@gmail.com>
Date: Sun, 15 Jul 2012 07:00:19 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <1341845396.3462.81.camel@twins> <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins> <4FFCBD00.1030109@gmail.com> <20120711071006.GF23898@redhat.com> <1342000187.3462.134.camel@twins> <20120711095337.GJ23898@redhat.com> <4FFE4E8D.90606@gmail.com> <20120712042923.GG7298@redhat.com> <4FFEEB55.5070009@gmail.com> <20120712160634.GI7298@redhat.com> <50027A36.9070509@redhat.com>
In-Reply-To: <50027A36.9070509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/15/12 2:07 AM, Avi Kivity wrote:
> On 07/12/2012 07:06 PM, Gleb Natapov wrote:
>>>
>>> Note the :pH this time.
>> I am not sure what perf kvm does with :pH modifier, but H modifier does
>> not make sense with perf kvm and should be reported as an error by perf tool.
>
> Maybe it should refer to the guest vs. the nested guest...

:H = host mode; you are thinking of :h for hypervisor mode. From 
perf-list documentation:

"Modifiers allow the user to restrict when events are
counted with 'u' for user-space, 'k' for kernel, 'h' for hypervisor.
Additional modifiers are 'G' for guest counting (in KVM guests) and 'H'
for host counting (not in KVM guests)."

>
> Well that's a horrible UI but we do need some way to distinguish among
> the two.  Samples from the nested guest's kernel will make no sense when
> looking at the guest kernel.  I guess we should default to exclude
> nested guest mode.
>

I catch a return flight in a couple of hours. I will send a summary 
email tonight to make sure we are on the same page with the problem, 
uses cases and patches.

David
