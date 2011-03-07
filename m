Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1CGVLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:11:20 -0500
Received: from kroah.org ([198.145.64.141]:47403 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517Ab1CGVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:11:19 -0500
Date: Mon, 7 Mar 2011 13:09:50 -0800
From: Greg KH <greg@kroah.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Pratheesh Gangadhar <pratheesh@ti.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de, tglx@linutronix.de, sshtylyov@mvista.com,
        arnd@arndb.de, amit.chatterjee@ti.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 1/1] PRUSS UIO driver support
Message-ID: <20110307210950.GA21433@kroah.com>
References: <1299279617-21108-1-git-send-email-pratheesh@ti.com>
 <1299279617-21108-2-git-send-email-pratheesh@ti.com>
 <20110305003004.GA1295@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110305003004.GA1295@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 05, 2011 at 01:30:04AM +0100, Hans J. Koch wrote:
> On Sat, Mar 05, 2011 at 04:30:17AM +0530, Pratheesh Gangadhar wrote:
> > This patch implements PRUSS (Programmable Real-time Unit Sub System)
> > UIO driver which exports SOC resources associated with PRUSS like
> > I/O, memories and IRQs to user space. PRUSS is dual 32-bit RISC
> > processors which is efficient in performing embedded tasks that
> > require manipulation of packed memory mapped data structures and
> > handling system events that have tight real time constraints. This
> > driver is currently supported on Texas Instruments DA850, AM18xx and
> > OMAP-L138 devices.
> > For example, PRUSS runs firmware for real-time critical industrial
> > communication data link layer and communicates with application stack
> > running in user space via shared memory and IRQs.
> > 
> > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> 
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> 
> I think, we've got it. Thanks for your contribution and your patience.
> Not many UIO programmers hang on through 11 patch versions...

Thanks so much for all of you doing this review as well, that too take
persistance :)

greg k-h
