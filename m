Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421Ab1ELJcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:32:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756112Ab1ELJcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:32:48 -0400
Date: Thu, 12 May 2011 11:32:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Wu, Josh" <Josh.wu@atmel.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, mchehab@redhat.com,
        linux-media@vger.kernel.org, "Haring, Lars" <Lars.Haring@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: RE: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)support
In-Reply-To: <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com>
Message-ID: <Pine.LNX.4.64.1105121131040.24486@axis700.grange>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
 <20110512074725.GA1356@n2100.arm.linux.org.uk>
 <4C79549CB6F772498162A641D92D532801AC28CD@penmb01.corp.atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:wb8gym7ssry2RXJ8zdsmd9x8XRke+yOwNpgC1DVfAaz
 JiDWhpNiqaxPcoUz4UqwGi6Fa2HoEQN0q6ugCEu+WZM6ezuG0x
 z/ovJmbdz9E8CrmwYSa1baa9f7uzFw3OLIrTCO0WaZiKWHLlyr
 md6Dp1jp4+gvdM9XtUi7v+scYZuVsTd1V5+6iFa5YWmsE4dDAS
 VFsYJ81ZaUGuPgJMSdl88Eb6S2sjzrVBzXQlNlunns=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 May 2011, Wu, Josh wrote:

> Hi, Russell
> 
> From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk] Sent: Thursday, May 12, 2011 3:47 PM
> > On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
> >> +err_alloc_isi:
> >> +	clk_disable(pclk);
> > clk_put() ?
> Ok, will be fixed in V2 patch. Thanks.

You might wait with v2 until I find time to review your patch. Will take a 
couple of days, I think. A general question, though: how compatible is 
this driver with the AVR32?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
