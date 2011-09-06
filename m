Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab1IFPeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:34:00 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:49344 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1IFPdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:33:55 -0400
From: Mike Sterling <Mike.Sterling@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Thread-Topic: [PATCH 1/1] staging: hv: Add support for >2 TB LUN in storage
 driver.
Thread-Index: AQHMaPE6HyE5989VjkieUpg0tUSbZ5U5jp8AgAbzYPA=
Date: Tue, 6 Sep 2011 15:33:53 +0000
Message-ID: <A19259D4D4D02A429E578F34E2857F9D4D212A38@TK5EX14MBXC203.redmond.corp.microsoft.com>
References: <1314915069-1796-1-git-send-email-mike.sterling@microsoft.com>
 <20110901222206.GA18024@suse.de>
In-Reply-To: <20110901222206.GA18024@suse.de>
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

On Thu, Sep 1, 2011 at 03:22:00PM +0800, Greg KH wrote:
>On Thu, Sep 01, 2011 at 03:11:09PM -0700, Mike Sterling wrote:
>> If a LUN larger than 2 TB is attached to a Linux VM on Hyper-V, we 
>> currently report a maximum size of 2 TB. This patch resolves the issue in hv_storvsc.
>> Thanks to Robert Scheck <robert.scheck@etes.de> for reporting the issue.
>> 
>> Reported-by: Robert Scheck <robert.scheck@etes.de>
>> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
>> Signed-off-by: K.Y. Srinivasan <kys@microsoft.com>
>> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>
>Much better, thanks.
>
>Is this something that needs to go to older kernels (3.0, 2.6.32, etc.) as well?

I discussed this with Ky. Given the changes that have taken place with the hv_* code, it's unlikely that this patch would just work with downlevel kernels. I'll need to create separate patches for those kernels.

-Mike
