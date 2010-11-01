Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0KAS1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:27:10 -0400
Received: from mail3.microsoft.com ([131.107.115.214]:8041 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab0KAS1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:27:07 -0400
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
Thread-Index: AQHLee2WbjO5faID10a9YXb0/O4IhpNc61eA
Date: Mon, 1 Nov 2010 18:27:04 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF728BA19E86@TK5EX14MBXC128.redmond.corp.microsoft.com>
References: <1288630429-12330-1-git-send-email-haiyangz@linuxonhyperv.com>
 <20101101174310.GA12632@suse.de>
In-Reply-To: <20101101174310.GA12632@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.72]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Monday, November 01, 2010 1:43 PM
> Why did I get two different copies of some of these patches?  Are they
> different?

They are the same.
Initially, I sent all 10 patches out at the same time, but I only saw 5 of them in my mail box. So I re-sent the 5 missing ones. Half hour later, I found the 5 previous missing emails were not lost, and received again at a later time.

> >  /* The one and only */
> > -struct hv_context gHvContext = {
> > -	.SynICInitialized	= false,
> > -	.HypercallPage		= NULL,
> > -	.SignalEventParam	= NULL,
> > -	.SignalEventBuffer	= NULL,
> > +struct hv_context g_hv_context = {
> 
> What is the "g_" for?  Why are you keeping the unneeded, and unwanted
> hungarian notation around?  Please don't do that.

The "g_" was used for global variables. I also saw some other global variables with the hungarian notation. Since this notation is not related to camel case conversion, how about we remove the hungarian notations in a separate patch?

Thanks,

- Haiyang

