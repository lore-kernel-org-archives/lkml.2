Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395Ab2FGTI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:08:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41926 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761349Ab2FGTIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:08:25 -0400
Message-ID: <4FD0FC26.3030101@gmail.com>
Date: Thu, 07 Jun 2012 12:08:22 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH RT 3/4] mips-remove-smp-reserve-lock.patch
References: <20120607155148.698959275@goodmis.org>	 <20120607155221.836885041@goodmis.org> <4FD0E9F9.60906@gmail.com> <1339095399.13377.2.camel@gandalf.stny.rr.com>
In-Reply-To: <1339095399.13377.2.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2012 11:56 AM, Steven Rostedt wrote:
> On Thu, 2012-06-07 at 10:50 -0700, David Daney wrote:
>> On 06/07/2012 08:51 AM, Steven Rostedt wrote:
>>> From: Thomas Gleixner<tglx@linutronix.de>
>>>
>>> Instead of making the lock raw, remove it as it protects nothing.
>>
>> I don't know how you guys are managing the RT branch, but this seems
>> quite similar to:
>>
>> a3c8b4faeeccb33dbad6969bc9e50bf409f167e7 (MIPS: Cavium: Remove
>> smp_reserve_lock.)
>
> Great! Then we don't need to worry about it :-)
>
> But as it doesn't seem that this patch was marked as stable, we will be
> carrying it in -rt where we support older kernels.
>
> Should it go to mainline stable?
>

I don't think it is necessary.  As far as I know, RT may be the only 
thing that needs it.

David Daney

> -- Steve
>
>>
>> David Daney
>>
>
>

