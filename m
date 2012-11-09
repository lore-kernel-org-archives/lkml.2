Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab2KIVql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:46:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:38656 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab2KIVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:46:23 -0500
Message-ID: <509D87B4.7060702@infradead.org>
Date: Fri, 09 Nov 2012 14:46:12 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: akpm@linux-foundation.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: Re: mmotm 2012-11-08-15-17 uploaded  (acpi)
References: <20121108231753.E6B7A100047@wpzn3.hot.corp.google.com> <509D862C.2060408@infradead.org> <alpine.DEB.2.00.1211091345080.2974@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1211091345080.2974@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 01:45 PM, David Rientjes wrote:

> On Fri, 9 Nov 2012, Randy Dunlap wrote:
> 
>> on x86_64:
>>
>> drivers/built-in.o: In function `acpi_pm_device_sleep_state':
>> (.text+0x21855): undefined reference to `acpi_target_system_state'
>> drivers/built-in.o: In function `acpi_pm_device_sleep_wake':
>> (.text+0x2198e): undefined reference to `acpi_target_system_state'
>> drivers/built-in.o: In function `acpi_dev_suspend_late':
>> (.text+0x21add): undefined reference to `acpi_target_system_state'
>>
> 
> Sent a fix for this yesterday: 
> http://marc.info/?l=linux-kernel&m=13524024192708


Thanks for both of those fixes.

-- 
~Randy
