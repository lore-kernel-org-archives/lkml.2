Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2FMOmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:42:11 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59261 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2FMOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:42:10 -0400
Date: Wed, 13 Jun 2012 10:42:06 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>, rob.herring@calxeda.com
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT
 information
In-Reply-To: <1339592984.8980.34.camel@twins>
Message-ID: <alpine.LFD.2.02.1206131038060.23555@xanadu.home>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org> <1339502524-10265-4-git-send-email-vincent.guittot@linaro.org> <1339592984.8980.34.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Peter Zijlstra wrote:

> On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> > +#ifdef CONFIG_OF
> 
> That must really be the worst CONFIG_ name ever..

Indeed!  We must corner Grant to do a s/CONFIG_OF/CONFIG_DEVICE_TREE/
on the whole tree and send the patch to Linus.  He just managed to 
chicken away from doing it so far.


Nicolas
