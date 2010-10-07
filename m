Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001Ab0JGHBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:01:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:37331 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab0JGHBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:01:09 -0400
Subject: Re: [PATCH] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC controllers (fix)
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <0778A3B9-E242-4BCC-B318-154BE9ECB2C6@kernel.crashing.org>
Date: Thu, 7 Oct 2010 02:00:50 -0500
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Scott Wood <scottwood@freescale.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
        linuxppc-dev@ozlabs.org, Doug Thompson <dougthompson@xmission.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <4A00FECC-3840-45E1-AB2A-6BDBD0FE09E0@kernel.crashing.org>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru> <20100716151224.21d499a3@schlenkerla.am.freescale.net> <20100721153933.64d02086.akpm@linux-foundation.org> <20100721182108.5a22c822@schlenkerla.am.freescale.net> <20100801105419.GA352@oksana.dev.rtsoft.ru> <5628792F-9A5F-4200-90B3-FB3939F02969@kernel.crashing.org> <20101007062909.GA27110@oksana.dev.rtsoft.ru> <0778A3B9-E242-4BCC-B318-154BE9ECB2C6@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2010, at 1:37 AM, Kumar Gala wrote:

>> @ -1125,7 +1128,10 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
>> 	{ .compatible = "fsl,mpc8569-memory-controller", },
>> 	{ .compatible = "fsl,mpc8572-memory-controller", },
>> 	{ .compatible = "fsl,mpc8349-memory-controller", },
>> +	{ .compatible = "fsl,p1020-memory-controller", },
>> +	{ .compatible = "fsl,p1021-memory-controller", },
>> 	{ .compatible = "fsl,p2020-memory-controller", },
>> +	{ .compatible = "fsl,p4080-memory-controller", },
> 
> This line should be here ;)

should NOT be here.

- k