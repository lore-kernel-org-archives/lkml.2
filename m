Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0HQRVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 13:21:01 -0400
Received: from mxout1.idt.com ([157.165.5.25]:50126 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0HQRU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 13:20:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 6/9] RapidIO: Add switch-specific sysfs initialization callback
Date: Tue, 17 Aug 2010 10:20:09 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D62F0@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6A37B3.70605@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 6/9] RapidIO: Add switch-specific sysfs initialization callback
thread-index: Acs92/p/d72gGBx5QKGPK4inmKsQyAAVDHcg
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-7-git-send-email-alexandre.bounine@idt.com> <4C692E4C.4040300@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5FFC@CORPEXCH1.na.ads.idt.com> <4C6A37B3.70605@neli.hopto.org>
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
> It's not problematic, but personally I find function calls that pass 0
> or 1 as an argument hard to read. Likewise for boolean parameters. An
> alternative would be to have defines SW_SYSFS_CREATE etc. It's a minor
item.
>

I will add defines.
