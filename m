Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab0CXI7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0CXI7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:59:46 -0400
Message-ID: <4BA9D459.6070502@redhat.com>
Date: Wed, 24 Mar 2010 10:59:05 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Joerg Roedel <joro@8bytes.org>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322173400.GB15795@elte.hu> <4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu> <4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws> <20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com> <20100323182153.GA14800@8bytes.org> <87hbo6fgpy.fsf@basil.nowhere.org> <4BA9B454.5090908@redhat.com> <20100324073854.GD20695@one.firstfloor.org>
In-Reply-To: <20100324073854.GD20695@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2010 09:38 AM, Andi Kleen wrote:
>> If you're profiling a single guest it makes more sense to do this from
>> inside the guest - you can profile userspace as well as the kernel.
>>      
> I'm interested in debugging the guest without guest cooperation.
>
> In many cases qemu's new gdb stub works for that, but in some cases
> I would prefer instruction/branch traces over standard gdb style
> debugging.
>    

Isn't gdb supposed to be able to use branch traces?  It makes sense to 
expose them via the gdb stub then.  Not to say an external tool doesn't 
make sense.


-- 
error compiling committee.c: too many arguments to function

