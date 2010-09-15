Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0IOSxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 14:53:50 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42673 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab0IOSxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 14:53:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
Date: Wed, 15 Sep 2010 11:52:58 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520130332B@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1682399277683944B902B3657D2FCE216544F4A1F0@CAREXCLUSTER03.ATL.CW.LOCAL>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 09/10] RapidIO: Add support for IDT CPS Gen2 switches
thread-index: ActUWruG03q/83K1SHqhkR/gwuIGNQAh6CIwAAgVINAAARR9cA==
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-10-git-send-email-alexandre.bounine@idt.com><20100914152049.8d42783f.akpm@linux-foundation.org> <0CE8B6BE3C4AD74AB97D9D29BD24E5520130321F@CORPEXCH1.na.ads.idt.com> <1682399277683944B902B3657D2FCE216544F4A1F0@CAREXCLUSTER03.ATL.CW.LOCAL>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Anderson, Trevor" <tanderson@curtisswright.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "Thomas Moll" <thomas.moll@sysgo.com>,
        <linuxppc-dev@lists.ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anderson, Trevor <tanderson@curtisswright.com> wrote:
> 
> Keep it in please. We lurkers in the embedded community do use the
per-port routing tables.
> One of the problems with SRIO switch tables is that access to routes
is not atomic; we can use
> restricted access to per-port routing tables to reduce the risk of
interference. And we still use
> the Global table during enumeration.
> 
Will it help if I add sysfs attribute(s) to handle per-port routes?
