Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab1JNTda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:33:30 -0400
Received: from mail2.microsoft.com ([131.107.115.215]:47665 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab1JNTd1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:33:27 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Oct 2011 15:33:27 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Mike Sterling <Mike.Sterling@microsoft.com>,
        NetDev <netdev@vger.kernel.org>
Subject: RE: [PATCH] staging: hv: move hv_netvsc out of staging area
Thread-Topic: [PATCH] staging: hv: move hv_netvsc out of staging area
Thread-Index: AQHMiqM7BEpK89aHNk+4pLHvcWE1AZV8q4KA//+MyFA=
Date: Fri, 14 Oct 2011 19:28:21 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC096F8090@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1318620026-8349-1-git-send-email-haiyangz@microsoft.com>
 <20111014191605.GA31039@suse.de>
In-Reply-To: <20111014191605.GA31039@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.33]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, October 14, 2011 3:16 PM
> Because of renames, the network developers really can't review this.
> I
> suggest posting a new patch, that just adds the driver to the
> drivers/net/ directory, and have the network developer review it that
> way.
> 
> Then, when it is accepted, I can delete the version in the staging
> directory.  We've done it this way for other drivers and it is the
> best
> way to get proper reviews as well as handling cross-subsystem merge
> issues.

During the previous review in June, Joe Perches suggested me to use -M 
option to show only changed code. But I will make a new patch to show 
all code according to your request.

Thanks,
- Haiyang

