Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1ELJ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:29:23 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27696 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab1ELJ3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:29:22 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
Date: Thu, 12 May 2011 17:26:59 +0800
Message-ID: <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com>
In-Reply-To: <20110512074725.GA1356@n2100.arm.linux.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
Thread-Index: AcwQeN63z2n57rr1Rf+dmJ4r6Vd5YwACYh+w
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com> <20110512074725.GA1356@n2100.arm.linux.org.uk>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: <mchehab@redhat.com>, <linux-media@vger.kernel.org>,
        "Haring, Lars" <Lars.Haring@atmel.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <g.liakhovetski@gmx.de>
X-OriginalArrivalTime: 12 May 2011 09:27:05.0073 (UTC) FILETIME=[C1D81E10:01CC1086]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Russell

From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] Sent: Thursday, May 12, 2011 3:47 PM
> On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
>> +err_alloc_isi:
>> +	clk_disable(pclk);
> clk_put() ?
Ok, will be fixed in V2 patch. Thanks.

Best Regards,
Josh Wu
