Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab1AZUO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:14:58 -0500
Received: from mail1.microsoft.com ([131.107.115.212]:36763 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1AZUO4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:14:56 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2011 15:14:55 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Dan Carpenter <error27@gmail.com>
CC: Hank Janssen <hjanssen@microsoft.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 7/8] staging: hv: Convert camel cased struct fields in
 vmbus_packet_format.h to lower cases
Thread-Topic: [PATCH 7/8] staging: hv: Convert camel cased struct fields in
 vmbus_packet_format.h to lower cases
Thread-Index: AQHLvYCLYvLUk9ofREuqc27yRn5vcJPkEe2A//+clQA=
Date: Wed, 26 Jan 2011 20:09:47 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC02482D@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-6-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
 <20110126180400.GS2721@bicker>
In-Reply-To: <20110126180400.GS2721@bicker>
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

> From: Dan Carpenter [mailto:error27@gmail.com]
> > +	VM_PKT_INVALID				= 0x0,
> > +	VM_PKT_SYNCH				= 0x1,
> > +	VM_PKT_ADD_XFER_PAGESET		= 0x2,
> > +	VM_PKT_RM_XFER_PAGESET		= 0x3,
>                                           ^^^^
> > +	VM_PKT_ESTABLISH_GPADL			= 0x4,
> > +	VM_PKT_TEARDOWN_GPADL			= 0x5,
> > +	VM_PKT_DATA_INBAND			= 0x6,
> > +	VM_PKT_DATA_USING_XFER_PAGES		= 0x7,
> > +	VM_PKT_DATA_USING_GPADL			= 0x8,
> > +	VM_PKT_DATA_USING_GPA_DIRECT		= 0x9,
> > +	VM_PKT_CANCEL_REQUEST			= 0xa,
> > +	VM_PKT_COMP			= 0xb,
>                                         ^^^^^^
> > +	VM_PKT_DATA_USING_ADDITIONAL_PKT	= 0xc,
> > +	VM_PKT_ADDITIONAL_DATA			= 0xd
> 
> 
> These don't line up with the others.

I have corrected and resubmitted them.

Thanks,
- Haiyang

