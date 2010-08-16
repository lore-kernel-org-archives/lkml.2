Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab0HPSUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 14:20:20 -0400
Received: from mxout1.idt.com ([157.165.5.25]:57165 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab0HPSUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 14:20:19 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
Date: Mon, 16 Aug 2010 11:18:59 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6061@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692F7E.1060208@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
thread-index: Acs9PoBpTnX//U7BQ1qaiRvDHSHTMQAL5uqQ
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <4C692F7E.1060208@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, "Thomas Moll" <thomas.moll@sysgo.com>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > This set of RapidIO patches adds support for new IDT Gen2 sRIO
switch
> > devices - CPS-1848 and CPS-1616.
> > Adding these sRIO switches required to implement standard error
recovery
> > mechanism defined by the RapidIO specification.
> 
> This is not 'Gen2' specific, as these error management extensions also
> exist in v1.2/1.3 (?) of the specification? E.g. tsi56x and tsi57x
could
> support this functionality?

Correct. EM extensions exist since v1.3. But implementation before Gen2
switches relied
on proprietary device specific mechanism (tsi57x). Addition of Gen2
switches just 
pushed forward the standard implementation. The RIO standard methods may
be used on 1.3 switches
(tested on tsi57x) as well as the standard routing table operations that
have been added
in our patches for 2.6.35.
    
> 
> Micha

Alex.

