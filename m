Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1HIMsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 08:48:25 -0400
Received: from mxout1.idt.com ([157.165.5.25]:44572 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab1HIMsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 08:48:23 -0400
X-Greylist: delayed 722 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 08:48:23 EDT
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] rio: Use discovered bit to test if enumeration is complete
Date: Tue, 9 Aug 2011 05:36:06 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552020244E5@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1312856226-3695-1-git-send-email-b34182@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] rio: Use discovered bit to test if enumeration is complete
Thread-Index: AcxWOnctAilG1DiZSVCzXuWudXwofgAVbRcA
References: <1312856226-3695-1-git-send-email-b34182@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Liu Gang" <b34182@freescale.com>, <linux-kernel@vger.kernel.org>
Cc: <r58472@freescale.com>, <r61911@freescale.com>, <linuxppc-dev@ozlabs.org>,
        "Liu Gang" <Gang.Liu@freescale.com>, <akpm@linux-foundation.org>,
        <B11780@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 08, 2011 at 10:17 PM, Liu Gang wrote:
> Subject: [PATCH] rio: Use discovered bit to test if enumeration is
> complete
> 
> The discovered bit in PGCCSR register indicates if the device has
> been discovered by system host. In Rapidio system, some agent devices
> can also be master devices. They can issue requests into the system.
> 
> Signed-off-by: Liu Gang <Gang.Liu@freescale.com>
> ---
>  drivers/rapidio/rio-scan.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Alexandre Bounine <alexandre.bounine@idt.com>

