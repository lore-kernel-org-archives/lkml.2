Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1AGRsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 12:48:14 -0500
Received: from smtp.microsoft.com ([131.107.115.212]:33512 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1AGRsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 12:48:13 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] staging: hv: Removed unneeded call to
 netif_stop_queue() in hv_netvsc
Thread-Topic: [PATCH 1/1] staging: hv: Removed unneeded call to
 netif_stop_queue() in hv_netvsc
Thread-Index: AQHLro85RRx21tUVtEWC29acRF/fIJPGSnmA//97NyA=
Date: Fri, 7 Jan 2011 17:48:11 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56233F397CF@TK5EX14MBXC114.redmond.corp.microsoft.com>
References: <1294421139-18657-1-git-send-email-hjanssen@microsoft.com>
 <20110107173139.GA12343@suse.de>
In-Reply-To: <20110107173139.GA12343@suse.de>
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



> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, January 07, 2011 9:32 AM
> 
> What kernel is this needed for, .37?  .38?  older than .37?
> 
> thanks,
> 
> greg k-h

This is needed for kernels 2.6.37 and newer.

Btw, I have not seen KVP patches that where submitted in linux next yet.
I have not seen any other requests for changes to them, is there anything else needed for acceptance?

Thanks,

Hank.

