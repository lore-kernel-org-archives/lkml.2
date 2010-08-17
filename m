Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0HQRQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:16:34 -0400
Received: from mxout1.idt.com ([157.165.5.25]:49943 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0HQRQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:16:32 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt handler
Date: Tue, 17 Aug 2010 10:16:08 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D62E8@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6A3665.7030207@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 2/9] RapidIO,  powerpc/85xx: modify RIO port-write interrupt handler
thread-index: Acs92zH3f/a5jFI4QyCBPxct/xQ59gAVFZfQ
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-3-git-send-email-alexandre.bounine@idt.com> <4C692B42.9050407@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F94@CORPEXCH1.na.ads.idt.com> <4C6A3665.7030207@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Primarily due to the single entry queue, the order of checking is
> probably insignificant? :-)

Help sometimes only but gives a feeling that I did all that is possible
;) 

> Anyway, I don't mind changing the order.
> 
> Micha
