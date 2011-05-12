Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1ELMti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 08:49:38 -0400
Received: from mxout1.idt.com ([157.165.5.25]:47414 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909Ab1ELMth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 08:49:37 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 08:49:37 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] RapidIO: Fix default routing initialization
Date: Thu, 12 May 2011 05:37:35 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201C8E515@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <20110511130024.955f1981.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] RapidIO: Fix default routing initialization
Thread-Index: AcwQFhQ+eLFVulWzSxOjKvzg10c8ZAAiuGfA
References: <1305125163-14590-1-git-send-email-alexandre.bounine@idt.com> <20110511130024.955f1981.akpm@linux-foundation.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Kumar Gala" <galak@kernel.crashing.org>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>, "Thomas Moll" <thomas.moll@sysgo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
 
> The changelog doesn't permit me to determine the importance of this
> fix,
> so I don't know whether to schedule it for 2.6.39 or for -stable.

Sorry, my fault. This patch is applicable to kernel versions starting
from 2.6.37.
