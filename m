Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2GBVwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:52:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62326 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932871Ab2GBVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:52:22 -0400
Date: Mon, 2 Jul 2012 22:52:03 +0100
From: Will Deacon <will.deacon@arm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: remove asm/locks.h
Message-ID: <20120702215203.GA25234@mudshark.cambridge.arm.com>
References: <1341262188.1911.147.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341262188.1911.147.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Jul 02, 2012 at 09:49:48PM +0100, Paul Bolle wrote:
> Commit 64ac24e738823161693bf791f87adc802cf529ff ("Generic semaphore
> implementation") removed the last include of this header. Apparently it
> was just an oversight to keep this header. It can safely be removed now.

Hmm, looks like you're right!

Acked-by: Will Deacon <will.deacon@arm.com>

> Tested only with various git commands on the (history of the) tree.

Not sure I follow, but since this is all dead code I can't see any tests
failing without it.

Will
