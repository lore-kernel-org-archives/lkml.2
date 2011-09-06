Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1IFTOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:14:08 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:32420 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab1IFTOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:14:04 -0400
From: Mike Sterling <Mike.Sterling@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Thread-Topic: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Thread-Index: AQHMaPE6HyE5989VjkieUpg0tUSbZ5VBM4+A//+L64A=
Date: Tue, 6 Sep 2011 19:14:01 +0000
Message-ID: <A19259D4D4D02A429E578F34E2857F9D4D217013@TK5EX14MBXC203.redmond.corp.microsoft.com>
References: <1314915069-1796-1-git-send-email-mike.sterling@microsoft.com>
 <20110906190615.GA31897@kroah.com>
In-Reply-To: <20110906190615.GA31897@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 06, 2011 12:06 PM, Greg KH wrote:
>On Thu, Sep 01, 2011 at 03:11:09PM -0700, Mike Sterling wrote:
>> If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we 
>> currently report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc.
>> Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.
>> 
>> Reported-by: Robert Scheck <robert.scheck@etes.de>
>> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
>> Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
>> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>> ---
>>  drivers/staging/hv/hyperv_storage.h |    1 +
>
>This file is no longer in the latest kernel tree (linux-next or staging-next).  What tree did you generate this patch against?  And >how come Haiyang and KY didn't catch such a basic mistake in their review...
>
>I'm guessing that this patch was not even tested :(
>
>Please fix this and resend.

Greg,

This patch was reviewed by both Ky and Haiyang. However, it looks like I built the patch against an older tree that didn't have Ky's changes. The "how" is still unclear, even after reviewing my steps with Ky. I've discussed this with Ky, I'm rebuilding the patch today, and will resubmit once we confirm.

-Mike
