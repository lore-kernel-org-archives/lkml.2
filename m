Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab1FIUYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 16:24:46 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:49002
	"EHLO CH1EHSOBE013.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755782Ab1FIUYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:24:42 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF12BFB.5030102@freescale.com>
Date: Thu, 9 Jun 2011 15:24:27 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <alan@lxorguk.ukuu.org.uk>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <cmetcalf@tilera.com>, <konrad.wilk@oracle.com>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <201106090929.23671.arnd@arndb.de> <4DF11715.5030001@freescale.com> <201106092220.22246.arnd@arndb.de>
In-Reply-To: <201106092220.22246.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> The lesson to learn here is obviously not to ship binaries of applications
> to customers before the driver has been merged in a mainline kernel.

Believe me, I know this, but unfortunately I have no control over every aspect
of our development cycle.

> The best way out that I can see is to make the driver carry the proper
> interface in the upstream version, but to have a private patch to support
> both interface versions in the kernel you ship on machines that require
> backwards compatibility. Once you have phased out the user application,
> you can then drop that patch and use the upstream version of the
> interfaces.

I think I can make that work.

-- 
Timur Tabi
Linux kernel developer at Freescale

