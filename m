Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2CWMfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:35:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40753 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758355Ab2CWMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:35:07 -0400
Date: Fri, 23 Mar 2012 13:35:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] x86: io_apic: Move and reenable irq only when
 CONFIG_GENERIC_PENDING_IRQ=y
Message-ID: <20120323123503.GH13920@gmail.com>
References: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320141935.GA24806@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> When CONFIG_GENERIC_PENDING_IRQ=n irq move and reenable code 
> is never get executed, nor do_unmask_irq variable updates its 
> init value. Move the code under CONFIG_GENERIC_PENDING_IRQ 
> macro.

It's not clear from the changelog what it does though, and the
#ifdefs are quite a mess. Does the patch fix some real bug? Or 
does it remove dead code from certain .config variations?

Thanks,

	Ingo
