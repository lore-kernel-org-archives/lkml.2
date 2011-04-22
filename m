Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373Ab1DVJWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:22:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35526 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab1DVJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Frnhr0DfT2vnJkoNPxuG4L/r1nD3ml5TjJYRDcD8cNfaOviF1a76rvVeDu4wWPkh6J
         8tGHlDsGq+uf7gTTrUCUOdkk5QuCeiTEmk2H9bAeOQmTQ11l20pwZ4Rtu7dBgI+vzpnP
         qABJaGS9yNWY6BDMIqjoISIDXjiQxCbtC1ptM=
Date: Fri, 22 Apr 2011 11:21:59 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V14 4/4] ptp: Added a clock driver for the National
 Semiconductor PHYTER.
Message-ID: <20110422092159.GA18708@riccoc20.at.omicron.at>
References: <cover.1303107532.git.richard.cochran@omicron.at>
 <1728ffb5735c2a04876a69ad55427c4e7b5a1bd7.1303107532.git.richard.cochran@omicron.at>
 <1303160245.2857.60.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303160245.2857.60.camel@bwh-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 09:57:25PM +0100, Ben Hutchings wrote:
> Would be better without the magic numbers.

Yes, of course, you are right, and also about patch #3.
Please take a look at v15 and see if it improves things.

Thanks,

Richard
