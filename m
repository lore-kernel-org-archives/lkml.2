Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab0I2Nmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:42:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:56282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab0I2Nmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,253,1283756400"; 
   d="scan'208";a="559025505"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
        "jdike@linux.intel.com" <jdike@linux.intel.com>
Date: Wed, 29 Sep 2010 21:41:54 +0800
Subject: RE: [PATCH v11 03/17] Add a ndo_mp_port_prep pointer to
 net_device_ops.
Thread-Topic: [PATCH v11 03/17] Add a ndo_mp_port_prep pointer to
 net_device_ops.
Thread-Index: ActeSdwEr+cuGcR3Q+yeDogOl81atABkhk6A
Message-ID: <F2E9EB7348B8264F86B6AB8151CE2D792EC64F8157@shsmsx502.ccr.corp.intel.com>
References: <1285388855-27410-1-git-send-email-xiaohui.xin@intel.com>
	 <79267b300503d98d43ccfcf11d1374f59fec8578.1285385607.git.xiaohui.xin@intel.com>
 <1285594953.2263.5.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1285594953.2263.5.camel@achroite.uk.solarflarecom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I will comment it above the structure.

Thanks
Xiaohui

>-----Original Message-----
>From: Ben Hutchings [mailto:bhutchings@solarflare.com]
>Sent: Monday, September 27, 2010 9:43 PM
>To: Xin, Xiaohui
>Cc: netdev@vger.kernel.org; kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
>mingo@elte.hu; davem@davemloft.net; herbert@gondor.hengli.com.au;
>jdike@linux.intel.com
>Subject: Re: [PATCH v11 03/17] Add a ndo_mp_port_prep pointer to net_device_ops.
>
>On Sat, 2010-09-25 at 12:27 +0800, xiaohui.xin@intel.com wrote:
>> From: Xin Xiaohui <xiaohui.xin@intel.com>
>>
>> If the driver want to allocate external buffers,
>> then it can export it's capability, as the skb
>> buffer header length, the page length can be DMA, etc.
>> The external buffers owner may utilize this.
>[...]
>
>This information needs to be included in the comment above struct
>net_device_ops, not just in the commit message.
>
>Ben.
>
>--
>Ben Hutchings, Senior Software Engineer, Solarflare Communications
>Not speaking for my employer; that's the marketing department's job.
>They asked us to note that Solarflare product names are trademarked.

