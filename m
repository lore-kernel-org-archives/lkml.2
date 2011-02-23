Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1BWWzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:55:16 -0500
Received: from mail2.microsoft.com ([131.107.115.215]:51382 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1BWWzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:55:15 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>, KY Srinivasan <kys@microsoft.com>
CC: Hank Janssen <hjanssen@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Topic: [PATCH 1/4] staging: hv: Fix the code depending on struct
 vmbus_driver_context data order
Thread-Index: AQHL05XXX+kAHBjdg0KWib5MQLs97JQQH60AgAAVwoCAAAEVgP//ep+Q
Date: Wed, 23 Feb 2011 22:55:12 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC060EE9@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <20110223212644.GC23766@kroah.com>
 <6E21E5352C11B742B20C142EB499E048014F2C@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110223224829.GA7175@kroah.com>
In-Reply-To: <20110223224829.GA7175@kroah.com>
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

> From: Greg KH [mailto:greg@kroah.com]
> The layering is almost ok, there is still one more layer here than is
> needed, and it should be removed (I already removed lots of layers that
> were not needed, just didn't get to this one.)  But the naming also
> needs to be fixed up as it is wrong from a "driver model" standpoint
> with the rest of the kernel.

So, how about rename the "struct driver_context" to "struct gen_drv_ctx"
in this patch? We can deal with the layering in next round of patches.

Thanks,

- Haiyang

