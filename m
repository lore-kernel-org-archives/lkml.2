Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab1AaOD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:03:28 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35911 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab1AaOD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:03:26 -0500
Message-ID: <4D46C0EB.9000505@linux.vnet.ibm.com>
Date: Mon, 31 Jan 2011 08:02:19 -0600
From: Anthony Liguori <aliguori@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <shemminger@vyatta.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jamie Lokier <jamie@shareable.org>, Thomas Weber <swirl@gmx.li>,
        Ben Hutchings <ben@decadent.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Andy Fleming <afleming@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: [RFC Patch] virtio: export model and type in /sys
References: <1296442381-21652-1-git-send-email-amwang@redhat.com> <201101311435.24531.rusty@rustcorp.com.au> <4D464C6F.7010601@redhat.com>
In-Reply-To: <4D464C6F.7010601@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 11:45 PM, Cong Wang wrote:
> (Adding Neil into Cc.)
>
> 于 2011年01月31日 12:05, Rusty Russell 写道:
>> On Mon, 31 Jan 2011 01:23:00 pm Amerigo Wang wrote:
>>> Our kdump script needs /sys/block/X/device/{vendor, model, type},
>>> but virtio devices don't have {model, type}, this patch adds them.
>>> Actually, I don't know how to fill the model field, other block devices
>>> seem read it from SCSI. Any comments?
>>
>> This seems deeply wrong.  Can't you fix your script?
>
> Well, we use (vendor, model, type) to identify a disk, and so far we only
> see virtio devices don't have this. So, we hope virtio at least provides
> some dummy files for us.

Uniquely identify the disk or identify the class of disk?

If it's the former, would serial be a better attribute to key off of?

Regards,

Anthony Liguori

>>
>> Model might sanely map to the feature bits, but making the type the same
>> as the PCI type is weird...
>>
>
> Yeah, that is why I mark the patch as RFC, I don't know which is the 
> correct way
> to fill these two values. Providing some dummy values is also fine for 
> us.
>
> Thanks.

