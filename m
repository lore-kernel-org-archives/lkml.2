Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab0LPQIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:08:22 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:48456 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab0LPQIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:08:21 -0500
Date: Thu, 16 Dec 2010 17:08:05 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Message-ID: <20101216160804.GI10333@enneenne.com>
Mail-Followup-To: Richard Cochran <richardcochran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
	netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
	David Miller <davem@davemloft.net>,
	John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <55b3188e735c3ce51608eef7926136d789182aa3.1292512461.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55b3188e735c3ce51608eef7926136d789182aa3.1292512461.git.richard.cochran@omicron.at>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH V7 5/8] ptp: Added a brand new class driver for ptp
 clocks.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 04:44:24PM +0100, Richard Cochran wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> presented as a standard POSIX clock.
> 
> The ancillary clock features are exposed in two different ways, via
> the sysfs and by a character device.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Regarding the PPS subsystem it looks ok for me.

Acked-by: Rodolfo Giometti <giometti@linux.it>

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
