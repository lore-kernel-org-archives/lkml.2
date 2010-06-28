Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0F2RiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:38:03 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:57035 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab0F2RiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:38:00 -0400
Date: Mon, 28 Jun 2010 14:36:06 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Egger <siccegge@cs.fau.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/9] Removing dead CONFIG_SOC_AU1000_FREQUENCY
Message-ID: <20100628133606.GA29229@linux-mips.org>
References: <cover.1275925108.git.siccegge@cs.fau.de>
 <2bd4314b3380c3c4aedd686f14187a80d00522e7.1275925108.git.siccegge@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bd4314b3380c3c4aedd686f14187a80d00522e7.1275925108.git.siccegge@cs.fau.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 01:20:23PM +0200, Christoph Egger wrote:

> CONFIG_SOC_AU1000_FREQUENCY doesn't exist in Kconfig, therefore
> removing all references for it from the source code.

Not comments received and seems to make sense so I queued this one for
2.6.36.

Thanks,

  Ralf
