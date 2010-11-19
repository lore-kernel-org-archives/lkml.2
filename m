Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0KSXQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:16:24 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:7798 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756907Ab0KSXQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:16:22 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAMOT5kxLd/sX/2dsb2JhbAAHgz3MRpEBgSKDNnMEhFo
X-IronPort-AV: E=Sophos;i="4.59,226,1288584000"; 
   d="scan'208";a="83026306"
Message-ID: <4CE70543.2000206@teksavvy.com>
Date: Fri, 19 Nov 2010 18:16:19 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>	<4CE5C919.7090504@teksavvy.com>	<AANLkTi=8G7pNA7QTxaXDWKrWrCERPfmKU+nLJWCA=JUH@mail.gmail.com>	<4CE7006E.4040102@teksavvy.com> <AANLkTim9aXi1_EJyh2f-+X4HnNWJ3uk2z=P6m1hQso5a@mail.gmail.com>
In-Reply-To: <AANLkTim9aXi1_EJyh2f-+X4HnNWJ3uk2z=P6m1hQso5a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-11-19 05:58 PM, Alex Deucher wrote:
> On Fri, Nov 19, 2010 at 5:55 PM, Mark Lord<kernel@teksavvy.com>  wrote:
>
>> It now comes back at resume time.
>
> So that patch helped?

I think so.  It didn't used to resume from suspend with 2.6.36, and now it does.

>> But suffers long delays (also sometimes with 2.6.35) doing this:
>>
>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>> aborting
>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576 (len
>> 105, WS 12, PS 8) @ 0xE5C4
>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>> aborting
>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing ECD2 (len
>> 86, WS 4, PS 0) @ 0xED05
>> [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs
>> aborting
>> [drm:atom_execute_table_locked] *ERROR* atombios stuck executing E576 (len
>> 105, WS 12, PS 8) @ 0xE5C4
>> PM: resume of devices complete after 15718.253 msecs
>>
>
> It's be nice if you could bisect to track down when those started.

It'd be even nicer if they hadn't started.  :)

What kernel release first had that atom/ops table in it?  I'll try that.
