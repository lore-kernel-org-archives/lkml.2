Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0HBRly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:41:54 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:52585 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0HBRlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:41:53 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops
Thread-Topic: [PATCH 1/1] staging: hv: Fix missing functions for
 net_device_ops
Thread-Index: AQHLMmQ5BGry+QOh3EmRF27A66ZhHpLO3dkA//+QKeA=
Date: Mon, 2 Aug 2010 17:41:46 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7280E8553D@TK5EX14MBXC121.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7280E8547C@TK5EX14MBXC121.redmond.corp.microsoft.com>
 <20100802171754.GA8213@suse.de>
In-Reply-To: <20100802171754.GA8213@suse.de>
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

> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, August 02, 2010 1:18 PM
>
> So what kernel versions are affected by this?
> 
> Please don't attach a patch and put it inline, it forces me to edit it
> by hand.
> 
> Care to provide the above information and resend it so I can apply it?

It affects kernel 2.6.32 and later, which are all versions contain Hyper-V drivers.
I will send out an email with the inline patch only.

Thanks,

- Haiyang

