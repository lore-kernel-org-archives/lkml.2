Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320Ab0FRRfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:35:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312Ab0FRRfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:35:24 -0400
Message-ID: <4C1B9FCD.2050306@redhat.com>
Date: Fri, 18 Jun 2010 06:33:17 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] Add timekeeping documentation
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-18-git-send-email-zamsden@redhat.com> <87mxuuujgm.fsf@basil.nowhere.org> <4C1A901F.2010802@redhat.com> <20100618074937.GA9045@basil.fritz.box>
In-Reply-To: <20100618074937.GA9045@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 09:49 PM, Andi Kleen wrote:
>> The point is about hotplug CPUs.  Any hotplugged CPU will not have a
>> perfectly synchronized TSC, ever, even on a single socket, single crystal
>> board.
>>      
> hotplug was in the next section, not in this.
>    

Yeah, I reread it and this section was totally confused.  Hopefully it 
makes more sense this time around.

> Besides most systems do not support hotplug CPUs.
>    

Yet.
