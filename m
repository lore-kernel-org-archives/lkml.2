Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab1JGKdm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:33:42 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36890 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759827Ab1JGKdk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:33:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
	<CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
	<alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
Date: Fri, 7 Oct 2011 16:03:39 +0530
Message-ID: <CAP05o4KLAnNHcvNbNWqJFN710JMNAy2emYzCt2xHF+m-Kvwveg@mail.gmail.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, khilman@ti.com,
        b-cousson@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 3:05 PM, Paul Walmsley <paul@pwsan.com> wrote:
> On Fri, 7 Oct 2011, Munegowda, Keshava wrote:
>
>> Thanks Paul;
>> yes, I can your changes in the patches.
>> so, you don't need v14 from me right? please confirm.
>> I am preparing/validating next version patches with  OCPIF_SWSUP_IDLE removed.
>> Thanks for guiding me and helping on the finalizing the hwmod configurations.
>
> The first two patches of the series -- the OMAP3/4 hwmod data patches --
> have been queued for 3.2 in the 'hwmod_devel_3.2' branch of
> git://git.pwsan.com/linux-2.6
>
> So we don't need new versions of those two.
>
> But we need to figure out what to do about the remaining three
> patches.  I still think that the TLL and UHH hwmods should have
> separate drivers.  Looks like Felipe has a question pending about that
> but it's unlikely that I'll have time to dig into it for at least a
> few days.  So I'd encourage you to try splitting those UHH and TLL
> drivers in the meantime.

some time last week; I had a discussion with Felipe and he is ok to
have current design as it is
for now; But, he wants to redesign this driver with UHH and TLL as two
platform drivers.
I will have discussion with Felipe and Partha to redesign it soon.

regards
keshava
