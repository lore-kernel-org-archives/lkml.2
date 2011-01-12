Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab1ALUd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:33:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182Ab1ALUdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:33:54 -0500
Message-ID: <4D2E1010.4080706@redhat.com>
Date: Wed, 12 Jan 2011 15:33:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com> <4D2C21FE.3000406@redhat.com>
In-Reply-To: <4D2C21FE.3000406@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 04:25 AM, Avi Kivity wrote:
> On 01/10/2011 09:31 PM, Linus Torvalds wrote:

>> Why wasn't I notified
>> before-hand? Was Andrew cc'd?
>
> Andrew and linux-mm were copied. Rik was the only one who reviewed (and
> ack'ed) it. I guess I should have explicitly asked for Nick's review.

Last time I reviewed it, FAULT_FLAG_ALLOW_RETRY did not
exist.  The async pagefault patches have been sitting in
limbo for quite a while...

Now that we have FAULT_FLAG_ALLOW_RETRY, the async
pagefault patches can be a little smaller.

-- 
All rights reversed
