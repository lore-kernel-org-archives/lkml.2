Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab0HQMpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:45:11 -0400
Received: from mxout1.idt.com ([157.165.5.25]:39257 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab0HQMpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:45:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 7/9] RapidIO: Add handling for PW message from a lost device
Date: Tue, 17 Aug 2010 05:44:25 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D61BF@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C6A38A4.6070505@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH 7/9] RapidIO: Add handling for PW message from a lost device
thread-index: Acs93I4p0jLYclOcSOykSob+r9M3pQAKuRjg
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-8-git-send-email-alexandre.bounine@idt.com> <4C692F31.2020705@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D6040@CORPEXCH1.na.ads.idt.com> <4C6A38A4.6070505@neli.hopto.org>
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
> Perhaps an idea is to use the repeated port-write sending feature so
> that dropped port-writes are not a problem anymore.
> 
Unfortunately, this feature is not defined by RIO spec. This is
proprietary function, so we 
cannot rely on it. Yes, this is nice feature of Tsi57x switches and may
be used if you have 
a closed system - just enable it in em_init. The RIO spec part 8 is
quite open about port-write generation and we cannot expect the same
behavior from different devices.    
