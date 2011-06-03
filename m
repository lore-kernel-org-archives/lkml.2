Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1FCOob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:44:31 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29232
	"EHLO CH1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751988Ab1FCOoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:44:30 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE8F347.9060104@freescale.com>
Date: Fri, 3 Jun 2011 09:44:23 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <kumar.gala@freescale.com>, <benh@kernel.crashing.org>, <greg@kroah.com>,
        <akpm@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de>
In-Reply-To: <201106012340.14237.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> For an ioctl, please follow the normal pattern of defining a separate
> structure for each case, no union.
> 
> You can use a void __user * in the common ioctl function, and pass that
> to the typed argument list in the specific functions.

I have a GPL question.  This header file is currently licensed under the  GPL v2
only.  Does that mean that any application that includes this header file so
that it can talk to the driver/hypervisor also needs to be licensed under the GPL?

-- 
Timur Tabi
Linux kernel developer at Freescale

