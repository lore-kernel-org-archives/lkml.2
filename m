Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab0FBHkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:40:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36668 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454Ab0FBHkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:40:46 -0400
Message-ID: <4C060ACC.7080103@zytor.com>
Date: Wed, 02 Jun 2010 00:39:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box>            <4C053ACC.5020708@redhat.com> <10707.1275413954@localhost>
In-Reply-To: <10707.1275413954@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 10:39 AM, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 01 Jun 2010 19:52:28 +0300, Avi Kivity said:
>> On 06/01/2010 07:38 PM, Andi Kleen wrote:
>>>>> Your new code would starve again, right?
>>> Try it on a NUMA system with unfair memory.
>
>> We are running everything on NUMA (since all modern machines are now
>> NUMA).  At what scale do the issues become observable?
>
> My 6-month-old laptop is NUMA? Comes as a surprise to me, and to the
> perfectly-running NUMA=n kernel I'm running.
>
> Or did you mean a less broad phrase than "all modern machines"?
>

All modern multisocket machines, unless configured in interleaved memory 
mode.

	-hpa

