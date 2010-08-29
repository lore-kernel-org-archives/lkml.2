Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab0H2Njq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:39:46 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:35776 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab0H2Njo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:39:44 -0400
X-Greylist: delayed 417 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Aug 2010 09:39:44 EDT
Message-ID: <4C7A6164.60208@riesch.at>
Date: Sun, 29 Aug 2010 15:32:20 +0200
From: Christian Riesch <christian@riesch.at>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Richard Cochran <richardcochran@gmail.com>,
        john stultz <johnstul@us.ibm.com>,
        Christian Riesch <christian.riesch@omicron.at>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
References: <363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>	<20100817085324.GB3330@riccoc20.at.omicron.at>	<1282090963.1734.97.camel@localhost>	<20100818071942.GA4096@riccoc20.at.omicron.at>	<1282176776.2865.100.camel@localhost.localdomain>	<20100819055518.GA4084@riccoc20.at.omicron.at>	<1282594125.3111.344.camel@localhost.localdomain>	<AANLkTi=nKrRHH6+9mvny718gov8Q+u7DHFikdgNY8YdX@mail.gmail.com>	<1282874269.4371.74.camel@localhost.localdomain>	<20100827075727.GA3818@riccoc20.at.omicron.at> <20100827134154.50eef56c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100827134154.50eef56c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: christian@riesch.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The master node in a PTP network probably takes its time from a
>> precise external time source, like GPS. The GPS provides a 1 PPS
>> directly to the PTP clock hardware, which latches the PTP hardware
>> clock time on the PPS edge. This provides one sample as input to a
>> clock servo (in the PTPd) that, in turn, regulates the PTP clock
>> hardware.
> 
> A PTP clock is TAI, Unix time is UTC.

Not necessarily. AFAIK, the time distributed by IEEE1588v2 can either be 
based on the "PTP epoch" (timePropertiesDS.ptpTimescale=TRUE) and thus 
represent TAI or be based on an implementation specific arbitrary epoch 
(timePropertiesDS.ptpTimescale=FALSE) and represent time on some 
arbitrary time scale.

Christian


