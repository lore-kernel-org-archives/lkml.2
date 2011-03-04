Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759951Ab1CDTwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:52:36 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:57521 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab1CDTwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:52:35 -0500
Date: Fri, 4 Mar 2011 20:50:37 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
Cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        tglx@linutronix.de, sshtylyov@mvista.com, arnd@arndb.de,
        amit.chatterjee@ti.com, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 1/1] PRUSS UIO driver support
Message-ID: <20110304195036.GF28175@local>
References: <1299213772-21931-1-git-send-email-pratheesh@ti.com>
 <1299213772-21931-2-git-send-email-pratheesh@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299213772-21931-2-git-send-email-pratheesh@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 10:12:52AM +0530, Pratheesh Gangadhar wrote:
> This patch implements PRUSS (Programmable Real-time Unit Sub System)
> UIO driver which exports SOC resources associated with PRUSS like
> I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> processors which is efficient in performing embedded tasks that
> require manipulation of packed memory mapped data structures and
> handling system events that have tight real time constraints. This
> driver is currently supported on Texas Instruments DA850, AM18xx and
> OMAP-L138 devices.
> For example, PRUSS runs firmware for real-time critical industrial
> communication data link layer and communicates with application stack
> running in user space via shared memory and IRQs.
> 
> Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/uio/Kconfig       |   17 +++
>  drivers/uio/Makefile      |    1 +
>  drivers/uio/uio_pruss.c   |  247 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/uio_pruss.h |   25 +++++
>  4 files changed, 290 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/uio/uio_pruss.c
>  create mode 100644 include/linux/uio_pruss.h

Make that include/linux/platform_data/uio_pruss.h as Greg said.
Otherwise, I don't see further issues, so I think we can take the next version.

Thanks,
Hans

