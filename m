Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2DMPZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:25:28 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:57905 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2DMPZ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:25:26 -0400
MIME-Version: 1.0
In-Reply-To: <4F8835B8.2060400@garzik.org>
References: <20120413081104.GA4953@gmail.com>
	<4F8835B8.2060400@garzik.org>
Date: Fri, 13 Apr 2012 23:25:25 +0800
Message-ID: <CANWLp01_fUhc72XUBcORGwh0s7r7g8CE5S7aqC+e2Sj4vf_DJA@mail.gmail.com>
Subject: Re: [RFC] enable FUA support in libata
From: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 10:18 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 04/13/2012 04:11 AM, Zheng Liu wrote:
>>
>> Hi Jeff and list,
>>
>> Recently I met a problem about FUA support of SATA disk.  In my machine,
>> it has a SATA disk that supports FUA feature.  But after system starts
>> up, it displays that the disk cannot support FUA from dmesg.
>>
>> I notice this commit (c3c013a2).  It disables FUA support in all of SATA
>> disk.  But the commit log is too simple to know why we should disable
>> FUA support in libata.  Could you please explain it?  Thank you.
>
>
> FUA support in the block layer wanted speed and guarantees that early FUA
> drives were simply not providing.

Hi Jeff,

Thank you for your reply.  I notice that this patch is merged in 2006.
 I don't know whether we can enable it now by default or not.  I read
some specifications of SATA disks.  They support FUA feature.
Although libata_fua variable is a kernel module parameter and we can
enable it when this module is loaded,  it is too complicated because
it needs to be loaded before kernel is loaded.  Thus, we need to set
libata_fua in initrd.  Maybe we can change it into a sysctl parameter.
 Then we can enable it dynamically.  Do you have any suggestions?
Thank you.

Regards,
Zheng
