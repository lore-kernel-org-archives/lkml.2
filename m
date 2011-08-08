Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1HHOSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 10:18:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235Ab1HHOSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 10:18:43 -0400
Message-ID: <4E3FF029.4060401@redhat.com>
Date: Mon, 08 Aug 2011 17:18:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Jan Beulich <jbeulich@novell.com>, hpa@linux.intel.com, mjg@redhat.com,
        linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86, efi: Don't recursively acquire rtc_lock
References: <4E3C30C602000078000740D5@nat28.tlf.novell.com> <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1312810836.10579.127.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 04:40 PM, Matt Fleming wrote:
> On Fri, 2011-08-05 at 18:04 +0100, Jan Beulich wrote:
> >
> >  Virtual platforms will have to take care of the serialization in the
> >  host anyway, so the guest side implementation of getwallclock et al
> >  is entirely unaffected.
>
> Ah, OK, that's the important part. I didn't realise that rtc_lock isn't
> actually required by any other code. In which case, yes, it completely
> makes sense to push the locking of rtc_lock down into the
> implementations that actually need it.
>
> It'd be great if I could get some ACK's from the virtualization guys.

Ack (for that aspect).

-- 
error compiling committee.c: too many arguments to function

