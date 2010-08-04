Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0HDE35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:29:57 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:15808 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0HDE34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:29:56 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 6/6] staging: hv: Gracefully handle SCSI resets
Thread-Topic: [PATCH 6/6] staging: hv: Gracefully handle SCSI resets
Thread-Index: AcszLVda8KYsB6WxTO6eplqBCGWJOAAQUHYAAAegKDA=
Date: Wed, 4 Aug 2010 04:28:17 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE7AE9@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D3C@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803174722.GG1455@suse.de>
In-Reply-To: <20100803174722.GG1455@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And then Greg spoke;
>>On Tue, Aug 03, 2010 at 05:31:56PM +0000, Hank Janssen wrote:
>> From: Hank Janssen <hjanssen@microsoft.com>
>> 
>> If we get a SCSI host bus reset we now gracefully handle it, and we take the device offline. 
>> This before sometimes caused hangs.
>
>Is this a problem for all older versions as well?  If so, should it be backported to the -stable kernel releases?

Yes, this should be backported to all stable kernel releases that have the Hyper-V drivers
In them.  This fixes a VM freeze.

All patches I submitted in the batch of 6 (Except for the TODO patch) fix bugs. This one
Fixes the worst one.

Thanks,

Hank.


