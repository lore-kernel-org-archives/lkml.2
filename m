Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0CWSHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:07:07 -0400
Received: from c60.cesmail.net ([216.154.195.49]:27486 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0CWSHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:07:04 -0400
Subject: Re: [git patches] libata fixes
From: Pavel Roskin <proski@gnu.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100323134226.GA14752@havoc.gtf.org>
References: <20100323134226.GA14752@havoc.gtf.org>
Content-Type: text/plain
Date: Tue, 23 Mar 2010 14:06:59 -0400
Message-Id: <1269367619.13592.12.camel@mj>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-23 at 09:42 -0400, Jeff Garzik wrote:
> This push includes a fix for the ata_piix timeouts people have been
> seeing...  it has seen several successful test reports, and is ready for
> wider testing in 2.6.34-rc.

Tested-by: Pavel Roskin <proski@gnu.org>

My OCZ Solid was giving me timeouts.  I thought it was about to die, so
I bought an Intel X-25M urgently, copied my data, but the timeouts
continued.

After some googling I found that a patch for that was sent this very
morning!  After applying the patch, the timeouts have stopped.  They
would appear minutes after reboot, but it has been over an hour since I
rebooted and no timeouts.

My motherboard is ECS G31T-M, which is not AHCI capable, so I was using
ata_piix, which explains why I was affected.  My kernel is 2.6.34-rc2
(actually, wireless-testing.git).

By all means, please push this patch to all stable kernels, or more
money will be wasted on hard drives ;-)

-- 
Regards,
Pavel Roskin
