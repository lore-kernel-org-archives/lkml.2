Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab0DTSyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab0DTSy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:54:29 -0400
Message-ID: <4BCDF85C.3000004@redhat.com>
Date: Tue, 20 Apr 2010 21:54:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>	 <4BCC3A3E.9070909@redhat.com>	 <20100419142158.GD14158@mothafucka.localdomain>	 <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org>
In-Reply-To: <4BCDF12C.1020702@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 09:23 PM, Jeremy Fitzhardinge wrote:
> On 04/20/2010 02:31 AM, Avi Kivity wrote:
>    
>> btw, do you want this code in pvclock.c, or shall we keep it kvmclock
>> specific?
>>      
> I think its a pvclock-level fix.  I'd been hoping to avoid having
> something like this, but I think its ultimately necessary.
>    

Did you observe drift on Xen, or is this "ultimately" pointing at the 
future?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

