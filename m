Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab1FPPDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:03:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32783 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1FPPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rNzLg7XGwkWS88lR7Iitjfrm2S/3eE1VaI20slOtXesSYJ9/I9BKdFVY5DZ/ZGuFVt
         gjSagECj1/HQLPS0PW5wvZEnpFiE7eANi5E6U+F+rcpL46A7yrgNu9QHR74htG0R95sQ
         5WGYCxxQmmHPyFlimhlgaRWKM2aFgdTknHgm8=
Message-ID: <4DFA1AC2.20605@gmail.com>
Date: Thu, 16 Jun 2011 23:01:22 +0800
From: Asias He <asias.hejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Prasad Joshi <prasadjoshi124@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar> <20110616142859.GA18356@redhat.com>
In-Reply-To: <20110616142859.GA18356@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 10:28 PM, Michael S. Tsirkin wrote:
> On Wed, Jun 15, 2011 at 06:53:34PM +0300, Pekka Enberg wrote:
>> Hi all,
>>
>> We’re proud to announce the second version of the Native Linux KVM tool! We’re
>> now officially aiming for merging to mainline in 3.1.
>>
>> Highlights:
>>
>> - Experimental GUI support using SDL and VNC
>>
>> - SMP support. tools/kvm/ now has a highly scalable, largely lockless driver
>>   interface and the individual drivers are using finegrained locks.
>>
>> - TAP-based virtio networking
> 
> Wanted to ask for a while: would it make sense to use vhost-net?
> Or maybe use that exclusively?
> Less hypervisor code to support would help the focus.
> 

Sure. We are planning to use vhost-net. Just out of time right now, we
are currently working on simple user model network support which allows
plain user to use network without root privilege.

-- 
Best Regards,
Asias He
