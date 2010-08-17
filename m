Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0HQSOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:14:22 -0400
Received: from mxout1.idt.com ([157.165.5.25]:52494 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0HQSOU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:14:20 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
Date: Tue, 17 Aug 2010 11:13:57 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6336@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6A3AD0.5090005@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 0/9] RapidIO: Set of patches to add Gen2 switches
thread-index: Acs93dbCXWNoApelQEqfuFQMJQHKpwAV8khw
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <4C692F7E.1060208@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6061@CORPEXCH1.na.ads.idt.com> <4C6A3AD0.5090005@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, "Thomas Moll" <thomas.moll@sysgo.com>,
        "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
 
> Can you explain what the difference what you mean with relied on
> proprietary vs standard? E.g. setting the port-write destination ID
> register is standardized? And the format of the port-write message
> itself is also.

The original description should use "error-stopped state recovery" term
instead of simple "error recovery".
And standard based handling of error-stopped states was added. I
mentioned tsi57x in that context because it uses proprietary mechanism
to generate "magic" control symbol to clear error-stopped states. Other
switches do not have similar function and have to rely on standard
implementation.
  
