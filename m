Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab0EZWDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:03:25 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:19643 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0EZWDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:03:22 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
       "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Topic: [PATCH 1/1] staging: hv: Fix race condition on IC channel
 initialization (modified)
Thread-Index: AQHK/PQk4Q0BKOsjtUu1BYK6E0Db25JkpeQA//+OILCAAIHWAP//jgAA
Date: Wed, 26 May 2010 22:03:20 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C5621B02619C@TK5EX14MBXC116.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7266B8C4AC@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526205134.GC7343@suse.de>
 <1FB5E1D5CA062146B38059374562DF7266B8C72B@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20100526214842.GA27908@suse.de>
In-Reply-To: <20100526214842.GA27908@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Wednesday, May 26, 2010 2:49 PM
> To: Haiyang Zhang
> Cc: 'linux-kernel@vger.kernel.org'; 'devel@driverdev.osuosl.org'; 
> 'virtualization@lists.osdl.org'; Hank Janssen
> Subject: Re: [PATCH 1/1] staging: hv: Fix race condition on IC channel 
> initialization (modified)
> On Wed, May 26, 2010 at 09:25:31PM +0000, Haiyang Zhang wrote:
>>> From: Greg KH [mailto:gregkh@suse.de]
>>> What's with the "ic_" naming scheme here?  It should be "hv_"
> right?
>> 
>> IC stands for "integration components", such as Shutdown, Timesync,
>> Heartbeat, etc.
> 
> Yes, I know what it stands for, but the rest of the world doesn't :)

Marketing in the their infinite wisdom decided that going forward they 
should be called Linux Integration Service so IS. 

Sigh..............

We will change it to hv_  :)

Hank.

