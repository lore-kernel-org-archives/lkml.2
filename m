Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966201Ab0GPUy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:54:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47079 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab0GPUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:54:57 -0400
Date: Fri, 16 Jul 2010 21:54:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Milton Miller <miltonm@bga.com>
Cc: Lee Jones <lee.jones@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Martin Michlmayr <tbm@cyrius.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -
	2.6.35-rc5
Message-ID: <20100716205445.GA28064@n2100.arm.linux.org.uk>
References: <4C408BEF.1060302@canonical.com> <4C3C72C6.4000005@canonical.com> <20100715130214.4c9303b2.akpm@linux-foundation.org> <20100715200618.GA6773@n2100.arm.linux.org.uk> <4C40218A.4090806@canonical.com> <20100716092018.GB16995@n2100.arm.linux.org.uk> <miltonm-arm-parport-1@bga.com> <miltonm-arm-parport-2@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <miltonm-arm-parport-2@bga.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 02:38:38PM -0500, Milton Miller wrote:
> I just looked at the 8250 code and it abuses the platform device model.
> Instead of a platform device for each port, it has multiple port
> descriptions set via platform_data in one or a a few device instances.

I don't agree with that assessment (but then I'm the one who created
that.)  Having one platform device for each port would have been
absurd given the number of ISA addresses that 8250 ports appear at.

Who'd want 64+ platform devices for serial ports?
