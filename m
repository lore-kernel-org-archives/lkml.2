Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2GCHUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 03:20:36 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3733 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039Ab2GCHUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 03:20:35 -0400
Message-ID: <1341300030.1911.179.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: remove asm/locks.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 03 Jul 2012 09:20:30 +0200
In-Reply-To: <20120702215203.GA25234@mudshark.cambridge.arm.com>
References: <1341262188.1911.147.camel@x61.thuisdomein>
	 <20120702215203.GA25234@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Jul 2012 07:20:30.0908 (UTC) FILETIME=[5409FFC0:01CD58EC]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Mon, 2012-07-02 at 22:52 +0100, Will Deacon wrote:
> On Mon, Jul 02, 2012 at 09:49:48PM +0100, Paul Bolle wrote:
> > Tested only with various git commands on the (history of the) tree.
> 
> Not sure I follow, but since this is all dead code I can't see any tests
> failing without it.

The purpose of that disclaimer is to stress that only git commands were
used to determine that removing this header is correct and safe. But
perhaps saying that I therefore "tested" this patch with git commands is
confusing.


Paul Bolle

