Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab1EWQQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 12:16:49 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:14778 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1EWQQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 12:16:47 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Christoph Hellwig <hch@infradead.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: vmbus driver
Thread-Topic: vmbus driver
Thread-Index: AQHMFm8184rvumQ7c0KLvy9LhTr6cJSWGtyA//+adbCAA3HcgIABOWxwgACI6gD//7MNEA==
Date: Mon, 23 May 2011 16:16:45 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481FC7E9@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1305842785-30206-1-git-send-email-kys@microsoft.com>
 <20110520122649.GA550@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481FC2ED@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <20110522105941.GB8346@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481FC6DF@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <alpine.LFD.2.02.1105231550360.3078@ionos>
In-Reply-To: <alpine.LFD.2.02.1105231550360.3078@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Monday, May 23, 2011 9:52 AM
> To: KY Srinivasan
> Cc: Christoph Hellwig; johnstul@us.ibm.com; gregkh@suse.de; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org;
> virtualization@lists.osdl.org
> Subject: RE: vmbus driver
> 
> On Mon, 23 May 2011, KY Srinivasan wrote:
> > I am working on getting Hyper-V drivers (drivers/staging/hv/*) out of staging.
> > I would like to request you to look at the Hyper-V timesource driver:
> > drivers/staging/hv/hv_timesource.c. The supporting code for this driver
> > is already part of the base kernel. Let me know if this driver is ready to exit
> staging.
> 
> Can you please send a patch against drivers/clocksource (the staging
> part is uninteresting for review).

Will do.

Regards,

K. Y


