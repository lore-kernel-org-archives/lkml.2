Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0HPSbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:31:01 -0400
Received: from mxout1.idt.com ([157.165.5.25]:57610 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab0HPSa7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:30:59 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 9/9] RapidIO: Add support for IDT CPS Gen2 switches
Date: Mon, 16 Aug 2010 11:30:39 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6074@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6930EA.8030406@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 9/9] RapidIO: Add support for IDT CPS Gen2 switches
thread-index: Acs9P1YRP7AebJ31S36rweSkFbNrpQAMNKBg
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-10-git-send-email-alexandre.bounine@idt.com> <4C6930EA.8030406@neli.hopto.org>
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
> Alexandre Bounine wrote:
> > +	rio_mport_write_config_32(mport, destid, hopcount,
> > +				  LOCAL_RTE_CONF_DESTID_SEL, table);
> > +
> > +	for (i = 0x80000000; i <= 0x800000ff;) {
> > +		rio_mport_write_config_32(mport, destid, hopcount,
> > +			RIO_STD_RTE_CONF_DESTID_SEL_CSR, i);
> 
> The 0x80000000 is that an autoincrement bit? If so, it only needs to
do
> this once I think? If so please call it like that, and loop the 'i'
> variable through the destination IDs.

No. This is EXTENDED_CONFIGURATION_ENABLE bit defined in Part 3 of RIO
spec (v.2.1, sect.3.5.4).
Anyway, I should add definition for this bit. Will do now.

Alex.
   
