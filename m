Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab2AKUlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 15:41:06 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:53839 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751097Ab2AKUlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 15:41:03 -0500
Message-ID: <4F0E017B.9060602@xenotime.net>
Date: Wed, 11 Jan 2012 13:39:07 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, sfr@canb.auug.org.au
Subject: Re: [RFC 0/14] Finish up irq_domain generalization
References: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1326313337-24603-1-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2012 12:22 PM, Grant Likely wrote:
> Here are the patches that I've been working on to finish up the creation
> of the generic irq_domain infrastructure.

Does this fix the linux-next build problems that I have reported?

https://lkml.org/lkml/2012/1/9/318


>  kernel/irq/irqdomain.c                           |  733 ++++++++++++++++++----

thanks,
-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
