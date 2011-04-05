Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab1DEPy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:54:58 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:42342 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab1DEPy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:54:57 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        "Abhishek Kane (Mindtree Consulting PVT LTD)" 
	<v-abkane@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Mike Surcouf <mike@surcouf.co.uk>, stable <stable@kernel.org>
Subject: RE: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Thread-Topic: [PATCH] staging: hv: Fix GARP not sent after Quick Migration
Thread-Index: AQHL86S7R40ZuTJlf0a7z4EkMMiktpRP3fCA//+NMeA=
Date: Tue, 5 Apr 2011 15:54:54 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC03FB03A6@TK5EX14MBXC223.redmond.corp.microsoft.com>
References: <1302017268-22913-1-git-send-email-haiyangz@microsoft.com>
 <20110405154133.GA30923@suse.de>
In-Reply-To: <20110405154133.GA30923@suse.de>
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
> Sent: Tuesday, April 05, 2011 11:42 AM
> But that's a hypervisor bug, right?  It shouldn't be sending a "connect"
> event on the ethernet device if the network really isn't present.  How
> about getting it fixed there, which will resolve the issues for all
> guest operating systems, not just Linux.
>
> Or, if this is something that the hyperv developers are not going to
> fix, we need to document it in the code itself so that people don't try
> to remove it in a few years as an "optimization".

Fix on the Hyper-V side is not available for now at least. I will add the
comments into code.

Thanks,
- Haiyang

