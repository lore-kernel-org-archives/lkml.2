Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab2CMPFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:05:14 -0400
Received: from mail.pce.us.com ([69.40.160.195]:47853 "EHLO mail.pce.us.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab2CMPFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:05:12 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 11:05:12 EDT
Message-ID: <4F5F60DB.9090801@itwatchdogs.com>
Date: Tue, 13 Mar 2012 09:59:39 -0500
From: Zach Sadecki <zsadecki@itwatchdogs.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Dong Aisheng <b29396@freescale.com>, <vinod.koul@linux.intel.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <rdunlap@xenotime.net>,
        <shawn.guo@freescale.com>, <kernel@pengutronix.de>, <cjb@laptop.org>,
        <s.hauer@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1 1/5] ARM: imx28: add basic dt support
References: <1331628428-24017-1-git-send-email-b29396@freescale.com> <1331628428-24017-2-git-send-email-b29396@freescale.com> <4F5F5B3F.2000303@gmail.com>
In-Reply-To: <4F5F5B3F.2000303@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.205.66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 09:35 AM, Rob Herring wrote:
> +	ahb@80080000 {
> +		fec@800f0000 {
> Use generic names: ethernet@800f0000
Generic is good, but consistency is better, IMHO.  grepping existing dts 
files in 3.2.9 finds 6 instances of "fec@" and 0 instances of "ethernet@"
>> +			uart1: uart@80074000 {
> Use generic names: uart1: serial@...
Same comment here, but unfortunately there is already inconsistency in 
existing files...  25 instances of "serial@" and 35 instances of "uart@"

