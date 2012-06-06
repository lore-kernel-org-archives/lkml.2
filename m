Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab2FFSEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:04:23 -0400
Received: from masquerade.micron.com ([137.201.242.130]:53208 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860Ab2FFSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:04:22 -0400
Message-ID: <4FCF9BA1.90308@micron.com>
Date: Wed, 6 Jun 2012 11:04:17 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
References: <4FCD0FC7.9010105@micron.com> <20120605093314.GC21560@kroah.com> <4FCE4D67.1030309@micron.com> <20120605202555.GA4727@kroah.com>
In-Reply-To: <20120605202555.GA4727@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18950.005
X-TM-AS-Result: No--18.024500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/2012 1:25 PM, Greg KH wrote:

> On Tue, Jun 05, 2012 at 11:18:15AM -0700, Asai Thambi S P wrote:
>> On 6/5/2012 2:33 AM, Greg KH wrote:
>>
>>> On Mon, Jun 04, 2012 at 12:43:03PM -0700, Asai Thambi S P wrote:
>>>>
>>>> This patch removes entries 'registers' and 'flags' from sysfs. Updated ABI file
>>>> to reflect this change.
>>>>
>>>> Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
>>>
>>> Much nicer, thanks for doing this:
>>>
>>> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> But, one question on a different sysfs file:
>>>
>>>>  What:           /sys/block/rssd*/status
>>>>  Date:           April 2012
>>>>  KernelVersion:  3.4
>>>>  Contact:        Asai Thambi S P <asamymuthupa@micron.com>
>>>>  Description:    This is a read-only file. Indicates the status of the device.
>>>
>>> What "status" is this showing?  Why is this a sysfs file?  Who
>>> needs/wants it?
>>
>>
>> This shows the device status - online, write_protect or thermal_shutdown. This
>> would be used by management application.
> 
> Is it used by a management application?  Shouldn't such a tool use the
> "standard" block device status files instead?  I thought we exported
> that information already in the /sys/block/* files.
> 


device status is not exported by standard block interface.

--
Regards,
Asai Thambi
