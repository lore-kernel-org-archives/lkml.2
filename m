Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1E0MGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:06:49 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:54791 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab1E0MGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:06:47 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
Date: Fri, 27 May 2011 20:06:26 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801CE4A21@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1105121131040.24486@axis700.grange>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
Thread-Index: AcwQh6rMPZbYdkb/Q9yWoT2kG1x4+QL3Vqqw
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com> <20110512074725.GA1356@n2100.arm.linux.org.uk> <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com> <Pine.LNX.4.64.1105121131040.24486@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, <mchehab@redhat.com>,
        <linux-media@vger.kernel.org>, "Haring, Lars" <Lars.Haring@atmel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 27 May 2011 12:06:31.0001 (UTC) FILETIME=[83C72490:01CC1C66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi

Sorry to answer the question so later, 

From: Guennadi Liakhovetski Sent: Thursday, May 12, 2011 5:32 PM
> On Thu, 12 May 2011, Wu, Josh wrote:

>> Hi, Russell
>> 
>> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] Sent: Thursday, May 12, 2011 3:47 PM
>> > On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
>> >> +err_alloc_isi:
>> >> +	clk_disable(pclk);
>> > clk_put() ?
>> Ok, will be fixed in V2 patch. Thanks.

> You might wait with v2 until I find time to review your patch. Will take a 
> couple of days, I think. A general question, though: how compatible is 
> this driver with the AVR32?
Now from the information I got from AVR team, The AVR32 is not compatible with  ISI driver patch v2. Since AVR32 use the previous version of ISI IP core. (AT91SAM9M10 using ISI_V2 IP, which has different hardware registers from V1 IP core, such like dma control, etc)
But I think in future we will add ISI V1 IP support since AT91SAM9263 also using ISI V1 IP core.

Best Regards,
Josh Wu
