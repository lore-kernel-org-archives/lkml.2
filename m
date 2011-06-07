Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab1FGTU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:20:57 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:2201
	"EHLO CH1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754212Ab1FGTU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:20:56 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DEE7A12.80302@freescale.com>
Date: Tue, 7 Jun 2011 14:20:50 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Chris Metcalf <cmetcalf@tilera.com>, <linuxppc-dev@lists.ozlabs.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <kumar.gala@freescale.com>, <linux-kernel@vger.kernel.org>,
        <akpm@kernel.org>, Deepak Saxena <dsaxena@linaro.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106070908.16301.arnd@arndb.de> <4DEE567E.7080102@tilera.com> <201106072116.21469.arnd@arndb.de>
In-Reply-To: <201106072116.21469.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> For the spi flash driver that goes through the hypervisor abstraction,
> I think drivers/virt/tile would be better than driver/platform/tile,
> but we should really have a new "abstract flash character driver" subsystem
> for that.

Why should it matter that the SPI flash driver goes through the hypervisor
abstration?  One of the patches in this patchset is a TTY driver that goes
through the Freescale hypervisor.  I put the drivers in drivers/tty.

-- 
Timur Tabi
Linux kernel developer at Freescale

