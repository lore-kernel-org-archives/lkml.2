Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab1BUO6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 09:58:41 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40541 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1BUO6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 09:58:40 -0500
Date: Mon, 21 Feb 2011 14:58:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/19] ARM: LPAE: use phys_addr_t instead of
	unsigned long for physical addresses
Message-ID: <20110221145818.GQ14495@n2100.arm.linux.org.uk>
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-16-git-send-email-catalin.marinas@arm.com> <20110219182631.GS29493@n2100.arm.linux.org.uk> <1298299008.19814.20.camel@e102144-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298299008.19814.20.camel@e102144-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 02:36:47PM +0000, Will Deacon wrote:
> Would you like me to submit an additional patch or are you happy merging
> this diff in with my ack?

The latter - I've already merged it and if you give an ack I'll add that.

Thanks.
