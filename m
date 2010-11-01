Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab0KAUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 16:48:34 -0400
Received: from mailb.microsoft.com ([131.107.115.215]:36611 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab0KAUsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 16:48:31 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 03/10] staging: hv: Convert camel cased struct fields	in
 hv.h to lower cases
Thread-Topic: [PATCH 03/10] staging: hv: Convert camel cased struct fields
	in hv.h to lower cases
Thread-Index: AQHLee2WbjO5faID10a9YXb0/O4IhpNc61eAgAB+VQD//65AMA==
Date: Mon, 1 Nov 2010 20:48:24 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728BA1BFA2@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1288630429-12330-1-git-send-email-haiyangz@linuxonhyperv.com>
 <20101101174310.GA12632@suse.de>
 <1FB5E1D5CA062146B38059374562DF728BA19E86@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20101101183918.GA453@suse.de>
In-Reply-To: <20101101183918.GA453@suse.de>
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
> Sent: Monday, November 01, 2010 2:39 PM
> How about you fix this patch in the series and resend them?
> 
> And if you look at the kernel, there is no "g_" for global variable
> names, so I don't want to see that as part of the history at all.
> 
> I'll drop these series and wait for an updated one.

I have fixed the "g_" variable, and re-sent the patch set.

Thanks,

- Haiyang
