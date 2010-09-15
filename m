Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0IOOFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:05:38 -0400
Received: from mxout1.idt.com ([157.165.5.25]:57167 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab0IOOFh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:05:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 01/10] RapidIO: Fix RapidIO sysfs hierarchy
Date: Wed, 15 Sep 2010 07:04:41 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520130318F@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100914150429.6256b311.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 01/10] RapidIO: Fix RapidIO sysfs hierarchy
thread-index: ActUWeyrMp5OHqJHSA6n11rBtzZh9wAfsWAQ
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-2-git-send-email-alexandre.bounine@idt.com> <20100914150429.6256b311.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Micha Nelissen" <micha@neli.hopto.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
 
> Non-backward compatible change?  What is the risk of breaking existing
> setups with this change?

I think that risk is very low. Assuming that this change brings sysfs
entries
to their intended hierarchy, it has sense to do it now (at relatively
early stage).

