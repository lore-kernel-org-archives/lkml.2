Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0IMCri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 22:47:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37509 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab0IMCrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 22:47:37 -0400
Message-ID: <4C8D9051.2070004@kernel.org>
Date: Sun, 12 Sep 2010 19:45:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: zersaa <zersaa@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Feng Tang <feng.tang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Bug #17772] Unable to locate IOAPIC for GSI *
References: <QnCvudbe2FD.A.XiE.DgSjMB@chimera> <p44oKaOqEDM.A.I2E.VgSjMB@chimera> <20100912202950.GA16751@elte.hu>
In-Reply-To: <20100912202950.GA16751@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2010 01:29 PM, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.34 and 2.6.35.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
>> be listed and let the tracking team know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=17772
>> Subject		: Unable to locate IOAPIC for GSI *
>> Submitter	: zersaa <zersaa@gmail.com>
>> Date		: 2010-09-04 21:28 (9 days old)
> 
> this is an error message introduced via ACPI commit:
> 
> | commit 2a4ab640d3c28c2952967e5f63ea495555bf2a5f
> | Author: Feng Tang <feng.tang@intel.com>
> | Date:   Tue Jul 7 23:01:15 2009 -0400
> |
> |     ACPI, x86: expose some IO-APIC routines when CONFIG_ACPI=n
> 
> It's not clear from the bugzilla entry whether it's just a new error 
> message, or an actual boot failure. It appears to me it's just a new 
> message - i.e. not a regression.
> 

can you post whole bootlog with "debug apic=debug"?

Thanks

Yinghai
