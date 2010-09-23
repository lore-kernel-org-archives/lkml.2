Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0IWVeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:34:17 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:36636 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab0IWVeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:34:14 -0400
Message-ID: <4C9BC7CE.8020400@riesch.at>
Date: Thu, 23 Sep 2010 23:34:06 +0200
From: Christian Riesch <christian@riesch.at>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Lameter <cl@linux.com>, john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
References: <cover.1285261533.git.richard.cochran@omicron.at>	<alpine.DEB.2.00.1009231238170.2962@router.home>	<1285268380.2587.11.camel@localhost.localdomain>	<alpine.DEB.2.00.1009231402420.2962@router.home>	<1285273684.2587.92.camel@localhost.localdomain>	<alpine.DEB.2.00.1009231533040.7522@router.home> <20100923223417.4ed62e5b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923223417.4ed62e5b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: christian@riesch.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> It implies clock tuning in userspace for a potential sub microsecond
>> accurate clock. The clock accuracy will be limited by user space
>> latencies and noise. You wont be able to discipline the system clock
>> accurately.
> 
> Noise matters, latency doesn't. 

Well put! That's why we need hardware support for PTP timestamping to 
reduce the noise, but get along well with the clock servo that is 
steering the PHC in user space.

Christian
