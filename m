Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab1CQTVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:21:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45003 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab1CQTVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:21:23 -0400
Date: Thu, 17 Mar 2011 13:21:16 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Scott Wood <scottwood@freescale.com>, Mike Frysinger <vapier@gentoo.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-api@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Paul Mackerras <paulus@samba.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rodolfo Giometti <giometti@linux.it>, Christoph Lameter <cl@linux.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH V11 2/4] ptp: Added a clock that uses the eTSEC found on
 the MPC85xx.
Message-ID: <20110317192116.GC12824@angua.secretlab.ca>
References: <cover.1298447722.git.richard.cochran@omicron.at>
 <be1f5e801e8cd0145dd23aadae7c2055bb3c1d47.1298447722.git.richard.cochran@omicron.at>
 <20110223165058.GE14597@angua.secretlab.ca>
 <20110223112612.30071995@schlenkerla>
 <20110223175459.GH14597@angua.secretlab.ca>
 <20110223132444.65dfdda4@schlenkerla>
 <20110224165004.GB15234@riccoc20.at.omicron.at>
 <20110224112731.2d9bf080@schlenkerla>
 <20110225075320.GA4032@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110225075320.GA4032@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 08:53:20AM +0100, Richard Cochran wrote:
> On Thu, Feb 24, 2011 at 11:27:31AM -0600, Scott Wood wrote:
> 
> > My vote, if it goes in a separate node at all, is "fsl,etsec-ptp",
> 
> So, that is what the patch does.
> 
> > and let the driver use SVR.
> 
> What is SVR?

An on chip register that provides the exact version of the SoC.  (As
opposed to PVR which is the version of the cpu core).

g.
