Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab1DJIF4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 04:05:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab1DJIFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 04:05:49 -0400
Message-ID: <4DA164B2.5000504@redhat.com>
Date: Sun, 10 Apr 2011 11:05:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Andrea Arcangeli <aarcange@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        mtosatti@redhat.com, kvm@vger.kernel.org, joro@8bytes.org,
        penberg@cs.helsinki.fi, asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu> <4D9E6F6E.9050709@codemonkey.ws> <BANLkTimEwAuL4PM9vBfogkrua-Z44AZQvg@mail.gmail.com> <4D9F150B.1030809@codemonkey.ws> <20110408192039.GJ29444@random.random> <4D9F9359.20708@codemonkey.ws>
In-Reply-To: <4D9F9359.20708@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2011 01:59 AM, Anthony Liguori wrote:
>
> Yeah, if that's the goal, skip all the mini-BIOS junk and just rely on 
> a PV kernel in the guest.
>
> I think a mini userspace that assumes that we can change the guest 
> kernel and avoids having a ton of complexity to do things like CMOS 
> emulation would be a really interesting thing to do.
>

Changing the guest kernel is a lot more complicated than writing a full 
BIOS or the legacy devices needed to support it.  See Xen for an example.

-- 
error compiling committee.c: too many arguments to function

