Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2CEGda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:33:30 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:34115 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2CEGd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:33:28 -0500
Message-ID: <4F545E2C.8080408@linux.vnet.ibm.com>
Date: Mon, 05 Mar 2012 12:03:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lenb@kernel.org, deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM/Sleep, ACPI: Teach acpi_cpu_soft_notify() to handle
 CPU hotplug in suspend/resume path
References: <20120228155137.3061.97133.stgit@srivatsabhat.in.ibm.com> <201203042333.18501.rjw@sisk.pl>
In-Reply-To: <201203042333.18501.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12030506-5564-0000-0000-000001AA8107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 04:03 AM, Rafael J. Wysocki wrote:

> On Tuesday, February 28, 2012, Srivatsa S. Bhat wrote:
>> acpi_cpu_soft_notify handles only CPU_ONLINE and CPU_DEAD events. However,
>> during a system-wide suspend/hibernation operation, CPU_ONLINE_FROZEN and
>> CPU_DEAD_FROZEN events are sent as part of CPU hotplug.
>>
>> Those events are really no different from regular CPU hotplug in this context,
>> and hence acpi shouldn't ignore them. So, teach acpi_cpu_soft_notify() to
>> handle those events as well.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>> I am no ACPI expert! So requesting a thorough review of this patch..
> 
> Well, as far as I can tell, it _looks_ correct.  That said, I don't think
> anyone will really tell you on the basis of code review alone, this requires
> testing.
> 
> Since Len hasn't been very responsive recently, I can take this patch into
> linux-pm/linux-next and see what the feedback is.


That would be great! Thanks a lot!

Regards,

Srivatsa S. Bhat

