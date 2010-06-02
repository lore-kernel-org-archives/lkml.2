Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0FBCq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab0FBCq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:46:57 -0400
Message-ID: <4C05C5F9.3050808@redhat.com>
Date: Wed, 02 Jun 2010 05:46:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box>            <4C053ACC.5020708@redhat.com> <10707.1275413954@localhost>
In-Reply-To: <10707.1275413954@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 08:39 PM, Valdis.Kletnieks@vt.edu wrote:
>> We are running everything on NUMA (since all modern machines are now
>> NUMA).  At what scale do the issues become observable?
>>      
> My 6-month-old laptop is NUMA? Comes as a surprise to me, and to the
> perfectly-running NUMA=n kernel I'm running.
>
> Or did you mean a less broad phrase than "all modern machines"?
>
>    

All modern two socket and above boards, sorry.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

