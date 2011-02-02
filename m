Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1BBCK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 21:10:59 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37088 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab1BBCK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 21:10:58 -0500
Subject: Re: [PATCH V10 14/15] ptp: Added a clock driver for the IXP46x.
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <0319138702479bc484596a2b10c681a7d8313b98.1296124770.git.richard.cochran@omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
	 <0319138702479bc484596a2b10c681a7d8313b98.1296124770.git.richard.cochran@omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 18:10:49 -0800
Message-ID: <1296612649.3336.213.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 12:00 +0100, Richard Cochran wrote:
> This patch adds a driver for the hardware time stamping unit found on the
> IXP465. The basic clock operations and an external trigger are implemented.
> 
> Signed-off-by: Richard Cochran <richard.cochran@omicron.at>

Minor nit below, but otherwise,
Acked-by: John Stultz <johnstul@us.ibm.com>

> diff --git a/drivers/ptp/ptp_ixp46x.c b/drivers/ptp/ptp_ixp46x.c
> new file mode 100644
> index 0000000..c860030
> --- /dev/null
> +++ b/drivers/ptp/ptp_ixp46x.c
[snip]
> +static int __init ptp_ixp_init(void)
> +{
> +	if (!cpu_is_ixp46x())
> +		return -ENODEV;
> +
> +	ixp_clock.regs = 
> +		(struct ixp46x_ts_regs __iomem *)IXP4XX_TIMESYNC_BASE_VIRT;

Minor whitespace issue here



