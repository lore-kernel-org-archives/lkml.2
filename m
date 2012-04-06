Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409Ab2DFSNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:13:08 -0400
Received: from masquerade.micron.com ([137.201.242.130]:44849 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2DFSNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:13:07 -0400
Message-ID: <4F7F322B.6060805@micron.com>
Date: Fri, 6 Apr 2012 11:12:59 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 2/5] mtip32xx: Add new sysfs entry 'status' and fix restart
 port
References: <4F7E07DC.50909@micron.com> <20120406011037.GA25892@kroah.com>
In-Reply-To: <20120406011037.GA25892@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.000.1038-18810.005
X-TM-AS-Result: No--13.708900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/2012 6:10 PM, Greg KH wrote:

> On Thu, Apr 05, 2012 at 02:00:12PM -0700, Asai Thambi S P wrote:
>>
>> * Add support for detecting the following device status
>> 	- write protect
>> 	- over temp (thermal shutdown)
>> * New sysfs entry 'status' created for this device,  possible values - online, write_protect, thermal_shutdown
> 
> All new (and existing) sysfs files must be documented in
> Documentation/ABI/ please do so for these new ones when you add them to
> the kernel.


I was not aware of this. Thanks. I will a add new file for mtip32xx driver.

--
Regards,
Asai Thambi
