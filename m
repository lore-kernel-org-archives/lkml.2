Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab2IYLOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:14:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1573 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2IYLOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:14:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 25 Sep 2012 04:05:23 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Date: Tue, 25 Sep 2012 16:44:34 +0530
Subject: RE: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Topic: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
Thread-Index: Ac2aHGHrWQkknqWSS16Zl73wm0SibwA8Yrrg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDF601838@BGMAIL02.nvidia.com>
References: <1348230054-7402-1-git-send-email-vbyravarasu@nvidia.com>
	<CAAe_U6K2hANpRqzyoiiP2mR97=M2Mb35+FVor11DaaZi7W9Pnw@mail.gmail.com>
	<505C9282.3050001@wwwdotorg.org>
	<D958900912E20642BCBC71664EFECE3E6DDF6014CF@BGMAIL02.nvidia.com>
 <CAAe_U6K3hcyv4Hi_8LM364qFakUagKfVdGh_2M4f7dFd-_kC4Q@mail.gmail.com>
In-Reply-To: <CAAe_U6K3hcyv4Hi_8LM364qFakUagKfVdGh_2M4f7dFd-_kC4Q@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: ABRAHAM, KISHON VIJAY [mailto:kishon@ti.com]
> Sent: Monday, September 24, 2012 11:48 AM
> To: Venu Byravarasu
> Cc: Stephen Warren; balbi@ti.com; gregkh@linuxfoundation.org; linux-
> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
> 
> Hi,
> 
> On Sat, Sep 22, 2012 at 2:08 PM, Venu Byravarasu
> <vbyravarasu@nvidia.com> wrote:
> >> -----Original Message-----
> >> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> >> Sent: Friday, September 21, 2012 9:45 PM
> >> To: ABRAHAM, KISHON VIJAY
> >> Cc: Venu Byravarasu; balbi@ti.com; gregkh@linuxfoundation.org; linux-
> >> kernel@vger.kernel.org; linux-usb@vger.kernel.org
> >> Subject: Re: [PATCH v3] USB: PHY: Re-organize Tegra USB PHY driver
> >>
> >> On 09/21/2012 07:09 AM, ABRAHAM, KISHON VIJAY wrote:
> >> > Hi,
> >> >
...
> >>
> >> ... where perhaps the use of defaults could be folded into
> >> parse_pdata_from_dt().
> >
> >
> > Thanks Stephen for the detailed explanation.
> >
> > Kishon / Felipe,
> > Do you have any more questions in this related, before patch can be
> applied?
> 
> I don't have any further comments.
> 
> Thanks
> Kishon

Felipe,

Can you plz merge this patch, if you don't have any objections?

Thanks,
Venu
