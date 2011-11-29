Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1K2SFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:05:14 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30654
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300Ab1K2SFM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:05:12 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432Nzz1202hzzz2fh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        NetDev <netdev@vger.kernel.org>
Subject: RE: [PATCH] staging: hv: move hv_netvsc out of staging area
Thread-Topic: [PATCH] staging: hv: move hv_netvsc out of staging area
Thread-Index: AQHMrhYAwM3L0fT04kOVI1luO2DccpXC0+WggAGp0gD//6iQkA==
Date: Tue, 29 Nov 2011 18:05:02 +0000
Message-ID: <A1F3067C9B68744AA19F6802BAB8FFDC0CCCD751@TK5EX14MBXC227.redmond.corp.microsoft.com>
References: <1322516135-22221-1-git-send-email-haiyangz@microsoft.com>
 <A1F3067C9B68744AA19F6802BAB8FFDC0CCCC087@TK5EX14MBXC227.redmond.corp.microsoft.com>
 <20111129151638.GB24688@kroah.com>
In-Reply-To: <20111129151638.GB24688@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.73]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, November 29, 2011 10:17 AM
> To: Haiyang Zhang
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; NetDev
> Subject: Re: [PATCH] staging: hv: move hv_netvsc out of staging area
> > I have rebased the previous patch on the latest staging-next branch,
> > and re-submitting it now.  In another email, the same patch was
> > submitted without using the "-M" flag, in case anyone wants to read
> > the unchanged code in the patch body.
> 
> This one was fine, now applied, thanks.

Thank you!

- Haiyang

