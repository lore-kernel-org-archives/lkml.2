Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1C1SHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:07:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:53657 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1C1SHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:07:02 -0400
Subject: Re: [PATCH V13 1/4] ptp: Added a brand new class driver for ptp
 clocks.
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <86641738e4c84fbdb105d6f2eb6141d5d13c3190.1301206090.git.richard.cochran@omicron.at>
References: <cover.1301206090.git.richard.cochran@omicron.at>
	 <86641738e4c84fbdb105d6f2eb6141d5d13c3190.1301206090.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 11:06:35 -0700
Message-ID: <1301335595.21829.0.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-27 at 08:38 +0200, Richard Cochran wrote:
> This patch adds an infrastructure for hardware clocks that implement
> IEEE 1588, the Precision Time Protocol (PTP). A class driver offers a
> registration method to particular hardware clock drivers. Each clock is
> presented as a standard POSIX clock.
> 
> The ancillary clock features are exposed in two different ways, via
> the sysfs and by a character device.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john


