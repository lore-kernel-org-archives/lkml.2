Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591Ab0JGNWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:22:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:51969 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760581Ab0JGNWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:22:42 -0400
Subject: Re: [PATCH] edac: mpc85xx: Add support for new MPCxxx/Pxxxx EDAC controllers (fix)
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <20101007071226.GA32189@oksana.dev.rtsoft.ru>
Date: Thu, 7 Oct 2010 08:21:47 -0500
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Scott Wood <scottwood@freescale.com>, Peter Tyser <ptyser@xes-inc.com>,
        linux-kernel@vger.kernel.org, Dave Jiang <djiang@mvista.com>,
        linuxppc-dev@ozlabs.org, Doug Thompson <dougthompson@xmission.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1B7E8A0C-6ADB-49A5-B21F-76D19364A96F@kernel.crashing.org>
References: <20100715182507.GA3482@oksana.dev.rtsoft.ru> <20100716151224.21d499a3@schlenkerla.am.freescale.net> <20100721153933.64d02086.akpm@linux-foundation.org> <20100721182108.5a22c822@schlenkerla.am.freescale.net> <20100801105419.GA352@oksana.dev.rtsoft.ru> <5628792F-9A5F-4200-90B3-FB3939F02969@kernel.crashing.org> <20101007062909.GA27110@oksana.dev.rtsoft.ru> <0778A3B9-E242-4BCC-B318-154BE9ECB2C6@kernel.crashing.org> <4A00FECC-3840-45E1-AB2A-6BDBD0FE09E0@kernel.crashing.org> <20101007071226.GA32189@oksana.dev.rtsoft.ru>
To: Anton Vorontsov <cbouatmailru@gmail.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2010, at 2:12 AM, Anton Vorontsov wrote:

> On Thu, Oct 07, 2010 at 02:00:50AM -0500, Kumar Gala wrote:
>> 
>> On Oct 7, 2010, at 1:37 AM, Kumar Gala wrote:
>> 
>>>> @ -1125,7 +1128,10 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
>>>> 	{ .compatible = "fsl,mpc8569-memory-controller", },
>>>> 	{ .compatible = "fsl,mpc8572-memory-controller", },
>>>> 	{ .compatible = "fsl,mpc8349-memory-controller", },
>>>> +	{ .compatible = "fsl,p1020-memory-controller", },
>>>> +	{ .compatible = "fsl,p1021-memory-controller", },
>>>> 	{ .compatible = "fsl,p2020-memory-controller", },
>>>> +	{ .compatible = "fsl,p4080-memory-controller", },
>>> 
>>> This line should be here ;)
>> 
>> should NOT be here.
> 
> Hm. Are you sure? I thought that only L2 cache controller is
> not applicable (and based on Scott's comment I removed
> the l2 cache compatible entry for p4080). But I guess
> memory-controller is somewhat similar to all other 85xx?
> 
> If it's not, I can surely prepare a patch that removes
> p4080 entry.
> 
> Thanks,

Your correct, late night and looking at the wrong line.  It was the L2 that should have been removed.  Ignore me.

- k