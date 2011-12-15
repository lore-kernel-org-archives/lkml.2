Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab1LOG4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:56:09 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:38287 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab1LOG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:56:08 -0500
Message-ID: <4EE999F9.7000804@eukrea.com>
Date: Thu, 15 Dec 2011 07:55:53 +0100
From: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Amit Kucheria <amit.kucheria@canonical.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/19] eukrea-cpuimx51: remove board
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-16-git-send-email-eric@eukrea.com> <20111213100532.GH27267@pengutronix.de> <4EE7253E.2030604@eukrea.com> <20111215035854.GA24039@avalanche>
In-Reply-To: <20111215035854.GA24039@avalanche>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Le 15/12/2011 04:58, Amit Kucheria a écrit :
 > On 11 Dec 13, Eric Bénard wrote:
 >> Hi Sascha,
 >>
 >> Le 13/12/2011 11:05, Sascha Hauer a écrit :
 >>> On Tue, Dec 13, 2011 at 07:31:48AM +0100, Eric Bénard wrote:
 >>>> this board is not maintained anymore and is replaced by cpuimx51sd
 >>>
 >>> I'm happy to remove this code, but aren't there any users of this board?
 >>>
 >> not any that would need a kernel upgrade considering the Freescale
 >> proprietary drivers used on it :-(
 >> Thanks,
 >> Eric
 >
 > Just for posterity, could you list the drivers that make an upgrade
 > impossible?
 >
at least gpu (AMD/FSL proprietary) & iirc video codecs (not all proprietary 
but far from mainline unless I missed something). In fact in the end these 
boards were using Freescale's kernel.

 > IMHO, if these boards were sold commercially we should maintain support if
 > there is a chance that we will get open drivers in the future.
 >
 > OTOH, if you can tell who each of these boards to, it is probably a good
 > target for removal. :)
 >
I confirm that's a good target for removal as our i.MX51 customers are 
actually using cpuimx51sd (actually without 3D & codecs actually but not 
everyone need these peripherals in industrial applications). Moreover, if all 
the drivers are mainlined we will be able to use dt if we want to upgrade 
cpuimx51.

Thanks,
Eric
