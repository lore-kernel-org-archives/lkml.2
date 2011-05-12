Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab1ELV64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 17:58:56 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:55958 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757968Ab1ELV6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 17:58:55 -0400
Date: Thu, 12 May 2011 22:57:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: wanlong.gao@gmail.com
Cc: linux@arm.linux.org.uk, hans-christian.egtvedt@atmel.com,
        benh@kernel.crashing.org, paulus@samba.org, david.woodhouse@intel.com,
        akpm@linux-foundation.org, u.kleine-koenig@pengutronix.de,
        mingo@elte.hu, rientjes@google.com, nicolas.ferre@atmel.com,
        eric@eukrea.com, tony@atomide.com, santosh.shilimkar@ti.com,
        khilman@deeprootsystems.com, ben-linux@fluff.org, sam@ravnborg.org,
        manuel.lauss@googlemail.com, galak@kernel.crashing.org,
        anton@samba.org, grant.likely@secretlab.ca, sfr@canb.auug.org.au,
        jwboyer@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] fix build warnings on defconfigs
Message-ID: <20110512215746.GB21865@linux-mips.org>
References: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302375858-11253-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 03:04:18AM +0800, wanlong.gao@gmail.com wrote:

> Subject: [PATCH] fix build warnings on defconfigs
> 
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
> since BT_L2CAP and BT_SCO had changed to bool configs.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

I've queued the MIPS bits only for 2.6.40.  Thanks.

  Ralf
