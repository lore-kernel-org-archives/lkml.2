Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab0HPNmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:42:44 -0400
Received: from mxout1.idt.com ([157.165.5.25]:45582 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753855Ab0HPNmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:42:43 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/9] RapidIO: Add the ingress port number into the RIO switch  data structure
Date: Mon, 16 Aug 2010 06:40:09 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F04@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C692BBB.8090707@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 3/9] RapidIO: Add the ingress port number into the RIO switch  data structure
thread-index: Acs9PEYuTBzUzZqvSkSzcPVd2Oa/cAAC0oBQ
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-4-git-send-email-alexandre.bounine@idt.com> <4C692BBB.8090707@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Micha Nelissen wrote:
> 
> Alexandre Bounine wrote:
> > A switch ingress port number has to be saved for software assisted
error
> > recovery from the error-stopped state. Saving this information also
allows
> > to remove several register reads from the RIO enumeration process.
> 
> Why not keep using the swpinfo field, as you can extract it from
there?
> And your code actually does this.
> 
> Also processor devices can have multiple ports (not only switches), it
> would be good to be ready for that use case.
> 
Agree. I missed the Multiport bit introduced in RIO spec 2.1. Now it is
justified to be as it was before.
I will rework this and next patches. 
