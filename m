Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0IONjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:39:43 -0400
Received: from mxout1.idt.com ([157.165.5.25]:55978 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947Ab0IONjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:39:42 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 06/10] RapidIO: Modify sysfs initialization for switches
Date: Wed, 15 Sep 2010 06:38:32 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201303168@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20100914151026.4d9599b4.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 06/10] RapidIO: Modify sysfs initialization for switches
thread-index: ActUWTniPu0Ilvv/Qpq2TW4US4KnFgAf6XzQ
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-7-git-send-email-alexandre.bounine@idt.com> <20100914151026.4d9599b4.akpm@linux-foundation.org>
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
 
> This is also a non-back compatible userspace-visible change?

This should be a safe change because endpoints do not have a routing
table.
RapidIO differentiates devices by using naming templates for switches
and endpoints (":s:" and ":e:") and this indicates which device features
are available to a userspace application.   

