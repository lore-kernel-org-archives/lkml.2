Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab1IGMHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:07:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54547 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1IGMHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 08:07:48 -0400
Date: Wed, 7 Sep 2011 12:47:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.1-rc1] ARM: entry: fix wrong parameter used in
	do_thumb_abort
Message-ID: <20110907114740.GS6619@n2100.arm.linux.org.uk>
References: <201108241307.21056.jkrzyszt@tis.icnet.pl> <201109071310.09266.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109071310.09266.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 01:10:08PM +0200, Janusz Krzysztofik wrote:
> Any plans to fix this regression before the rc cycle is over, or at 
> least explain why it won't be fixed?

Apart from the patch being buried beneath a ton of email, and then
being shuffled off into my "August 2011" mailbox which doesn't get
looked at... no.

> Any special requirements as to the process of submitting bug fixes 
> against arch/arm common bits?

It needs to go into the patch system for merging so that it doesn't
get buried and forgotten - as already demonstrated.
