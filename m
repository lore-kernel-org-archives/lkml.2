Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1AZWrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:47:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47091 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZWrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:47:10 -0500
Date: Wed, 26 Jan 2011 22:46:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dima Zavin <dmitriyz@google.com>
Cc: David Brown <davidb@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 02/11] msm: Generalize timer register mappings
Message-ID: <20110126224649.GC7323@n2100.arm.linux.org.uk>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1295468747-22796-1-git-send-email-davidb@codeaurora.org> <1295468747-22796-3-git-send-email-davidb@codeaurora.org> <1295908604.29639.62.camel@c-dwalke-linux.qualcomm.com> <8yaei81kjlc.fsf@huya.qualcomm.com> <AANLkTi=UBfBp-VOQ=n_a4sjA9v_dhcv-rXcXiE6zrf23@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=UBfBp-VOQ=n_a4sjA9v_dhcv-rXcXiE6zrf23@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 02:12:59PM -0800, Dima Zavin wrote:
> To be honest I don't understand why you would want to do this at
> runtime. You cannot select multiple SoCs in the kernel build anyway,
> nor would you want to. Trying to have same kernel to boot on ARM v6
> and ARM v7 would already be freaky enough.

Wrong.  We already have that working with mainline plus some additional
patches.  OMAP people want it, and it's precisely the direction which
quite a number of people within the ARM community want to move.

Building an ARM kernel to cover multiple different CPU types is something
which has always been possible, although with SMP and a few other things
it's become a little harder.  Not impossible though, and not impossible
to do efficiently either.
