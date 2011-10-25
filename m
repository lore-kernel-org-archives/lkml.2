Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1JYCne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 22:43:34 -0400
Received: from mailc.microsoft.com ([131.107.115.214]:8488 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab1JYCnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 22:43:33 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <greg@kroah.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "ohering@suse.com" <ohering@suse.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: vmbus: Support building the vmbus
 driver as part of the kernel
Thread-Topic: [PATCH 1/1] Staging: hv: vmbus: Support building the vmbus
 driver as part of the kernel
Thread-Index: AQHMkqAExdpVY1SsrkaDm6NhGDwEYJWMy1OA//+Of5A=
Date: Tue, 25 Oct 2011 02:43:31 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481AA39D21@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1319488265-26936-1-git-send-email-kys@microsoft.com>
 <20111025022717.GA32457@kroah.com>
In-Reply-To: <20111025022717.GA32457@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.20]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Monday, October 24, 2011 10:27 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@suse.com;
> Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: vmbus: Support building the vmbus driver
> as part of the kernel
> 
> On Mon, Oct 24, 2011 at 01:31:05PM -0700, K. Y. Srinivasan wrote:
> > Modify the way we initialize the vmbus driver so that all the hyper-v drivers
> > can be linked with the kernel and still ensure that the vmbus driver
> > is fully initialized before the drivers that depend upon the vmbus
> > driver attempt to initialize.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Any reason you sent this out twice?  Was there a difference between the
> two versions that I missed?

No difference. It is the mail server acting up. After I sent the mail initially,
it did not go out for several hours. I sent it again and after several hours, both were
sent out. Sorry for the confusion; you can ignore one of them.

Regards,

K. Y
> 
> greg k-h

