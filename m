Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1C1SIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:08:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:44544 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1C1SIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:08:12 -0400
Subject: Re: [PATCH V13 3/4] ptp: Added a clock driver for the IXP46x.
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
In-Reply-To: <706adc379f5f64dfad665cb8f831f44050b59eae.1301206090.git.richard.cochran@omicron.at>
References: <cover.1301206090.git.richard.cochran@omicron.at>
	 <706adc379f5f64dfad665cb8f831f44050b59eae.1301206090.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Mar 2011 11:07:54 -0700
Message-ID: <1301335674.21829.2.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-27 at 08:39 +0200, Richard Cochran wrote:
> This patch adds a driver for the hardware time stamping unit found on the
> IXP465. The basic clock operations and an external trigger are implemented.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Acked-by: John Stultz <john.stultz@linaro.org>

