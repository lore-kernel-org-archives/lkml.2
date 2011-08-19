Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab1HSMb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 08:31:58 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37663 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378Ab1HSMbz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 08:31:55 -0400
MIME-Version: 1.0
In-Reply-To: <20110819113953.GM23101@legolas.emea.dhcp.ti.com>
References: <1313753646-29089-1-git-send-email-keshava_mgowda@ti.com>
	<20110819113953.GM23101@legolas.emea.dhcp.ti.com>
Date: Fri, 19 Aug 2011 18:01:53 +0530
Message-ID: <CAP05o4KFJ984KTxKu=aNd4OdSkTdCvT_RgFQ6pw8yRDFyprB_A@mail.gmail.com>
Subject: Re: [PATCH 0/5 v6] mfd: omap: usb: Runtime PM support for EHCI and
 OHCI drivers
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, gadiyar@ti.com, sameo@linux.intel.com,
        parthab@india.ti.com, tony@atomide.com, khilman@ti.com,
        b-cousson@ti.com, paul@pwsan.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com, tom.leiming@gmail.com, toddpoynor@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 5:10 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Aug 19, 2011 at 05:04:01PM +0530, Keshava Munegowda wrote:
>> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>>
>> The Hwmod structures and Runtime PM features are implemented
>> For EHCI and OHCI drivers of OMAP3 and OMAP4.
>> The global suspend/resume of EHCI and OHCI
>> is validated on OMAP3430 sdp board with these patches.
>>
>> these patches are rebased to kevin's pm branch and
>> usbhs latest mainline kernel patches
>>
>> TODO:
>>      - Aggressive clock cutting in usb bus suspends
>>      - Remote Wakeup implementation using irq-chaining
>
> what happened with V5 ? I didn't see any comments to that one. Please
> start adding your changes here too.

I rebased (trival) on anand gadiyar's TLL patch, covered typos and re tested on
omap3 and omap4 again.
I know its simple thing to do, but I don't want to see any merge
conflicts by sameo or anybody.
I request, if you have any comments please let me know so that we can
freeze this patch series
before I complete the development of  aggressive clock cutting/remote
wakeup other wise
I am requesting you ack-by :-)

keshava
