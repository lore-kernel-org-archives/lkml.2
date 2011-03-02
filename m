Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1CBNYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 08:24:05 -0500
Received: from www.tglx.de ([62.245.132.106]:56089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1CBNYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 08:24:03 -0500
Date: Wed, 2 Mar 2011 14:23:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Pratheesh Gangadhar <pratheesh@ti.com>
cc: linux-kernel@vger.kernel.org, hjk@hansjkoch.de, gregkh@suse.de,
        sshtylyov@mvista.com, arnd@arndb.de, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v8 1/1] PRUSS UIO driver support
In-Reply-To: <1299065886-30099-2-git-send-email-pratheesh@ti.com>
Message-ID: <alpine.LFD.2.00.1103021421390.2701@localhost6.localdomain6>
References: <1299065886-30099-1-git-send-email-pratheesh@ti.com> <1299065886-30099-2-git-send-email-pratheesh@ti.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Pratheesh Gangadhar wrote:

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

No further objections.

Thanks for your patience,

       tglx

