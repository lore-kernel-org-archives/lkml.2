Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0IIOxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:53:11 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:8891 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0IIOxJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:53:09 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Convert vmbus driver interface
 function pointer table to constant
Thread-Topic: [PATCH 1/1] staging: hv: Convert vmbus driver interface
 function pointer table to constant
Thread-Index: ActQLpKWkH6pOyCTToqeu+wzUKGkuA==
Date: Thu, 9 Sep 2010 14:53:03 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF72854C94CE@TK5EX14MBXC130.redmond.corp.microsoft.com>
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
> Sent: Wednesday, September 08, 2010 6:44 PM
> > Convert vmbus driver interface function pointer table to constant
> > The vmbus interface functions are assigned to a constant - vmbus_ops.
> 
> You also remove a function pointer in this patch, why?  Please break up
> the patch into logical parts, one patch, one thing.
> 
> This looks like it should be 2 patches, right?

Because the vmbus interface function pointer table is converted to a
constant variable -- vmbus_ops, the function GetChannelInterface(),
VmbusGetChannelInterface() and pointer GetChannelInterface are no longer
in use. The deprecated function's work is done by the initialization of
the newly added constant variable vmbus_ops.

I created the new constant variable vmbus_ops and removed the deprecated
function pointer GetChannelInterface in one patch.

Thanks,

- Haiyang

