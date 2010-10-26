Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab0JZRSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:18:30 -0400
Received: from mxout1.idt.com ([157.165.5.25]:43811 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279Ab0JZRS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:18:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Date: Tue, 26 Oct 2010 10:17:50 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D9BA@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4CC6E43C.8010104@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 0/2] RapidIO: Changes to handling of RIO switches
Thread-Index: Act1GU6F7UA1HludQSOmmkPeQiBOBAAB7SWQ
References: <1287688250-14226-1-git-send-email-alexandre.bounine@idt.com> <4CC0AD74.8070800@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445906@CORPEXCH1.na.ads.idt.com> <4CC1D7DE.7060405@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445A6B@CORPEXCH1.na.ads.idt.com> <4CC20923.8050400@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201445BA4@CORPEXCH1.na.ads.idt.com> <4CC5ACAB.7070309@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D5C2@CORPEXCH1.na.ads.idt.com> <4CC5E354.80009@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520147D879@CORPEXCH1.na.ads.idt.com> <4CC6E43C.8010104@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen <micha@neli.hopto.org> wrote:
> 
> In various parts of the enumeration and routing algorithm, it would
need
> to lookup the tag to find the destid, if the destid is in the tag then
> this lookup is not needed.

Let's keep this discussion within limits of the current implementation.
Existing method of forming CT may be replaced when that change is
justified by use.
Any method that may be implemented later is good if it ensures unique
identification of RIO devices. At this moment, we just need to define CT
format now to avoid future conflicts of enumeration methods.

> Well, we both know "the current mainline implementation" is easily
> improved to unique identification I proposed. Therefore this statement
> is misleading.

Your improvement will require assigning separate destID to any switch
that has no endpoints attached. I prefer to keep changes to enumeration
for later patches.

Alex.

