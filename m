Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0HDEfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:35:10 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:49069 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab0HDEfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:35:07 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Topic: [PATCH 1/6] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Index: AcszLH4zXLsEPQuASP+5uxzSPyjpcgAQLtUAAAgzgxA=
Date: Wed, 4 Aug 2010 04:35:06 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE8B19@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD0D21@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173732.GA1455@suse.de>
In-Reply-To: <20100803173732.GA1455@suse.de>
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


And then Greg spoke:
>>On Tue, Aug 03, 2010 at 05:31:51PM +0000, Hank Janssen wrote:
>> From: Hank Janssen <hjanssen@microsoft.com>
>> 
> >Fixed bounce offset kmap problem by using correct index
>
>Is this a bugfix that needs to go to previous kernel releases?  If so, which ones?  What is the symptom of the problem here?

Yes, this should be backported to all stable kernel releases that have the Hyper-V drivers In them.  

The symptom of the problem is that in some NAS appliances this problem represents
Itself by a unresponsive VM under a load with many clients writing small files.

I actually goofed up in my previous code and used an incorrect index number
For this part of the code. It should have shown up in more situations than what
I have seen oddly enough.

Hank.

