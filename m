Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0HDEcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:32:20 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:16622 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066Ab0HDEcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:32:19 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>
Subject: RE: [PATCH 2/6] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list
Thread-Topic: [PATCH 2/6] staging: hv: Fixed lockup problem with
 bounce_buffer scatter list
Thread-Index: AcszLN0XE1cvJoW/S1u5tYxf4xhZuwAQI8eAAAgDUZA=
Date: Wed, 4 Aug 2010 04:32:17 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FE7AF6@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56223FD1D29@TK5EX14MBXC114.redmond.corp.microsoft.com>
 <20100803173857.GB1455@suse.de>
In-Reply-To: <20100803173857.GB1455@suse.de>
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
>> On Tue, Aug 03, 2010 at 05:31:53PM +0000, Hank Janssen wrote:
>> From: Hank Janssen <hjanssen@microsoft.com>
> >
> >Fixed lockup problem with bounce_buffer scatter list which caused crashes in heavy loads.
>
>Same questions for you as patch 1/6.
>
>Also, please wrap your changelog comments at 72 columns.
 
Under heavy loads with many clients we this problem appears, it causes a kernel 
Panic.

Yes, this should be backported to all stable kernel releases that have the 
Hyper-V drivers In them.  

>> Signed-off-by:Hank Janssen <hjanssen@microsoft.com> 
>> Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
>
>What's with the trailing space?

Same problem as wrapping my comments at 72  chars, I just upgraded to the latest
Evil outlook 2010, and my settings in office 2007 did not transfer so I have to 
Set up all the stuff that fixes these problems :(

Do you want me to re-submit with correct wrapping?

Thanks,

Hank.

