Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab1FBGzc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 02:55:32 -0400
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59677 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932545Ab1FBGzb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 02:55:31 -0400
MIME-Version: 1.0
In-Reply-To: <87hb89gwar.fsf@ti.com>
References: <1306934847-6098-1-git-send-email-keshava_mgowda@ti.com>
	<1306934847-6098-2-git-send-email-keshava_mgowda@ti.com>
	<87hb89gwar.fsf@ti.com>
Date: Thu, 2 Jun 2011 12:25:28 +0530
Message-ID: <BANLkTinQ=yrNs_giSVL5-UPXqJJG2at0Xw@mail.gmail.com>
Subject: Re: [PATCH 1/4] arm: omap: usb: ehci and ohci hwmod structures for
 omap3 and omap4
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        b-cousson@ti.com, paul@pwsan.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 1:26 AM, Kevin Hilman <khilman@ti.com> wrote:
> Keshava Munegowda <keshava_mgowda@ti.com> writes:
>
>> Following 2 hwmod strcuture are added:
>> UHH hwmod of usbhs with uhh base address and
>> EHCI , OHCI irq and base addresses.
>> TLL hwmod of usbhs with the TLL base address and irq.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>
> I believe the OMAP4 data came from Benoit, so should be in a patch with
> his authorship and signoff.  OMAP3 can be a separate patch with your
> authorship.

yes , you are right.
I apologizes for this. Benoit should be author.

>
> Kevin
>
