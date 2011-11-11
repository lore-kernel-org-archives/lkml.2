Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab1KKTJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 14:09:40 -0500
Received: from smtp.infotech.no ([82.134.31.41]:48538 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756932Ab1KKTJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 14:09:38 -0500
Message-ID: <4EBD72E9.4020805@interlog.com>
Date: Fri, 11 Nov 2011 14:09:29 -0500
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Nao Nishijima <nao.nishijima.xt@hitachi.com>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
References: <20111109162512.GB1260@google.com> <4EBD361E.5040106@hitachi.com> <20111111173633.GA24351@suse.de>
In-Reply-To: <20111111173633.GA24351@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-11-11 12:36 PM, Greg KH wrote:
> On Fri, Nov 11, 2011 at 11:50:06PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> Finally, I understood why this patch is not acceptable and would like to
>> solve the problem of the device name mismatch in *user space* using
>> udev. So, could you please give me your comment about it?
>>
>> I aim to unify the device name because the name shown in command output
>> is different from it that users use for command execution.
>>
>> So, I'd like to suggest that two new API should be added to udev.
>> - The API that returns any symlinks such as by-uuid, by id that users
>>    selected before if a device name is given as arguments
>>    If the commands directly access to proc filesystems, they cannot get
>>    the symlinks. These commands should get the device name via this API.
>> - The API that replaces device name to symlink in text messages
>> 　　The dmesg and syslog messages include the raw device names such as
>>    sdX. They should be replaced with symlinks to unify the device names.
>> - udev support alias
>>    Symlinks (by-uuid, by-id …) is too long, compared to before (e.g.
>>    sdX). I guess most of users need more friendly and short names.
>>
>> Could you give me some advice or comments?
>> (I will post this idea udev mailing list with prototype code)
>
> Patches are always best to work off of, please post your changes to udev
> to the linux-hotplug list and we can take it from there.

... and getting examples of acceptable code and APIs
for that purpose might help the requester (and others)
produce those patches.

Doug Gilbert


