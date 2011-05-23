Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918Ab1EWUsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:48:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18146 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1EWUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:48:47 -0400
Date: Mon, 23 May 2011 13:48:15 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
Message-Id: <20110523134815.fb87933a.randy.dunlap@oracle.com>
In-Reply-To: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090205.4DDAC81E.00BB:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 15:45:18 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110520:

when CONFIG_GPIOLIB is not enabled
and CONFIG_GENERIC_GPIO is not enabled:

sound/soc/codecs/ak4641.c:524: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
sound/soc/codecs/wm8915.c:2857: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
