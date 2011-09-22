Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1IVNgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 09:36:15 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:39160 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144Ab1IVNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 09:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVOoHM14AqqH0CSpwNPef1QL+7MtgZOQZhYVSdgA=5KR4g@mail.gmail.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<CACVXFVOoHM14AqqH0CSpwNPef1QL+7MtgZOQZhYVSdgA=5KR4g@mail.gmail.com>
Date: Thu, 22 Sep 2011 19:06:10 +0530
Message-ID: <CAP05o4L5h5J7YBupH2KJJ5Bbmdq+a78Z_OORETtnLj59ZtSZJw@mail.gmail.com>
Subject: Re: [PATCH 0/5 v11] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, b-cousson@ti.com, paul@pwsan.com,
        balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 7:02 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> Hi,
>
> On Thu, Sep 22, 2011 at 7:37 PM, Keshava Munegowda
> <keshava_mgowda@ti.com> wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The Hwmod structures and Runtime PM features are implemented
>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>> The global suspend/resume of EHCI and OHCI
>> is validated on OMAP3430 sdp board with these patches.
>>
>> These patches are re-based to Kevin's pm branch :
>> git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git
>
> Is kernel.org up now? :-)
>
> thanks,
> --
> Ming Lei


no!

its kevin tree, which  i took it 3 weeks back. :-(

regards
keshava
