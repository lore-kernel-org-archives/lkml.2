Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab1LLXp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:45:29 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:44233
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab1LLXpY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:45:24 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371I542M1432N98dK4015Lzz1202hzz8275bhz2fh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:none;EFVD:NLI
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as
 part of the kernel
Thread-Topic: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as
 part of the kernel
Thread-Index: AQHMuPhClG1KZdmWWEy34GvkN5Ecu5XZTo4A//+ORgA=
Date: Mon, 12 Dec 2011 23:44:30 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AD7FDDF@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1323710931-29616-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-1-git-send-email-kys@microsoft.com>
 <1323710959-29655-4-git-send-email-kys@microsoft.com>
 <20111212222712.GA13510@kroah.com>
In-Reply-To: <20111212222712.GA13510@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, December 12, 2011 5:27 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> Haiyang Zhang
> Subject: Re: [PATCH 4/4] Drivers: hv: Support building the vmbus driver as part of
> the kernel
> 
> On Mon, Dec 12, 2011 at 09:29:19AM -0800, K. Y. Srinivasan wrote:
> > Support building the vmbus driver as part of the kernel.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> This was already applied to my tree, I don't know why you missed it...

Thanks Greg. I pulled down your tree yesterday (staging.git) and checked out
the staging-next branch and did not find the fix needed to build this driver
as part of the kernel. I will check again.

Thanks,

K. Y



