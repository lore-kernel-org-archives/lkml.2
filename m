Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1IBNbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 09:31:07 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:50812 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1IBNbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 09:31:01 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Thread-Topic: [PATCH 1/1] Staging: hv: Integrate the time source driver with
 Hyper-V detection code
Thread-Index: AQHMUSsDaFcj5XUHz0iCpe32+jahhJU6Y4aA///irKA=
Date: Fri, 2 Sep 2011 13:30:59 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E048081B5ECD@TK5EX14MBXC126.redmond.corp.microsoft.com>
References: <1312300982-11609-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.02.1109021013390.2723@ionos>
In-Reply-To: <alpine.LFD.2.02.1109021013390.2723@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, September 02, 2011 4:14 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; andi@firstfloor.org;
> akpm@linux-foundation.org; x86@kernel.org; Haiyang Zhang
> Subject: Re: [PATCH 1/1] Staging: hv: Integrate the time source driver with Hyper-
> V detection code
> 
> On Tue, 2 Aug 2011, K. Y. Srinivasan wrote:
> 
> > The Hyper-V timesource driver is best integrated with Hyper-V detection code
> > since: (a) Linux guests running on Hyper-V need this timesource and (b)
> > by integrating with Hyper-V detection, we could significantly  minimize the
> > code in the timesource driver.
> >
> > Andrew, could you take this patch for the -mm tree. I have sent this patch
> > out multiple times and I have not recived any response or comments.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> Acked-by: Thomas Gleixner <tglx@linutronix.de>

Thanks Thomas. As you are one of the maintainers, would you be
taking this patch?

Regards,

K. Y 
