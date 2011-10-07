Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab1JGO1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 10:27:21 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37372 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752663Ab1JGO1T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 10:27:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAP05o4LMjfwGMtYH02XTv9UqO7nEPSu2fijnOPceVjK-dyUgwg@mail.gmail.com>
References: <1317901099-2519-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1110070305040.4611@utopia.booyaka.com>
	<CAP05o4J39MotDTOv-O2ahvWfxL-7jC-L3FGsNXbmDy8HNg=W3g@mail.gmail.com>
	<alpine.DEB.2.00.1110070330220.4611@utopia.booyaka.com>
	<CAP05o4LMjfwGMtYH02XTv9UqO7nEPSu2fijnOPceVjK-dyUgwg@mail.gmail.com>
Date: Fri, 7 Oct 2011 19:57:18 +0530
Message-ID: <CAP05o4+KMrFc6QHVdzuw6qR6BzkHxsSDssA=B0A_TS8fWp-mbg@mail.gmail.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>, sameo@linux.intel.com, balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        gadiyar@ti.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 4:13 PM, Munegowda, Keshava
<keshava_mgowda@ti.com> wrote:
> On Fri, Oct 7, 2011 at 3:05 PM, Paul Walmsley <paul@pwsan.com> wrote:
>> On Fri, 7 Oct 2011, Munegowda, Keshava wrote:
>>
>>> Thanks Paul;
>>> yes, I can your changes in the patches.
>>> so, you don't need v14 from me right? please confirm.
>>> I am preparing/validating next version patches with  OCPIF_SWSUP_IDLE removed.
>>> Thanks for guiding me and helping on the finalizing the hwmod configurations.
>>
>> The first two patches of the series -- the OMAP3/4 hwmod data patches --
>> have been queued for 3.2 in the 'hwmod_devel_3.2' branch of
>> git://git.pwsan.com/linux-2.6
>
> Ok, then I will host a tree for remaining three patches and another
> last patch for MFD tree.

Hi Felipe and Sameo

The patches are available in the branch kmg-usbhs-pm of
git repository: git@gitorious.org:~kmg/mirrors/kmg-usbhs-pm.git

if you have review comment on v13 of these series; please let me know.
so I that I will make the changes in time.

 regards
 keshava


>
>> So we don't need new versions of those two.
>>
>> But we need to figure out what to do about the remaining three
>> patches.  I still think that the TLL and UHH hwmods should have
>> separate drivers.  Looks like Felipe has a question pending about that
>> but it's unlikely that I'll have time to dig into it for at least a
>> few days.  So I'd encourage you to try splitting those UHH and TLL
>> drivers in the meantime.
>>
>>
>> - Paul
>>
>
