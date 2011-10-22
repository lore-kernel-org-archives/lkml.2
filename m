Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab1JVGlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 02:41:42 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:5004 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab1JVGll convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 02:41:41 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v4 1/3] [media] at91: add code to enable/disable ISI_MCK clock
Date: Sat, 22 Oct 2011 14:41:08 +0800
Message-ID: <4C79549CB6F772498162A641D92D5328031B11E0@penmb01.corp.atmel.com>
In-Reply-To: <Pine.LNX.4.64.1110171702370.18438@axis700.grange>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v4 1/3] [media] at91: add code to enable/disable ISI_MCK clock
Thread-Index: AcyM3nKBXISZX8QoSjWmc5YVyxtPowDpmAvg
References: <1318331020-22031-1-git-send-email-josh.wu@atmel.com> <1318331020-22031-2-git-send-email-josh.wu@atmel.com> <Pine.LNX.4.64.1110171702370.18438@axis700.grange>
From: "Wu, Josh" <Josh.wu@atmel.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Cc: <linux-media@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>, <s.nawrocki@samsung.com>
X-OriginalArrivalTime: 22 Oct 2011 06:41:13.0942 (UTC) FILETIME=[97D74760:01CC9085]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guennadi

On Monday, October 17, 2011 11:04 PM, Guennadi Liakhovetski wrote:

> From: Josh Wu <josh.wu@atmel.com>
>
> This patch
> - add ISI_MCK clock enable/disable code.
> - change field name in isi_platform_data structure
>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> [g.liakhovetski@gmx.de: fix label names]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

> Josh, I missed a slight hick-up in the previous version of this your 
> patch, so, I fixed it myself. Please confirm, that this version is ok
with 
> you.

> Thanks
> Guennadi

I confirm that the patch is ok for me. Thank you.

Best Regards,
Josh Wu
