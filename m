Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab0G0F4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:56:11 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:59597 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0G0F4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:56:07 -0400
Date: Tue, 27 Jul 2010 06:55:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbdev: Make jz4740-fb depends on MACH_JZ4740
Message-ID: <20100727055546.GA5469@linux-mips.org>
References: <20100727111422.673b4919.sfr@canb.auug.org.au>
 <1280197979-24307-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280197979-24307-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 04:32:59AM +0200, Lars-Peter Clausen wrote:

> The jz4740-fb driver should only be selectabed of MACH_JZ4740 is selected.

Thanks, folded into the original patch.

  Ralf
