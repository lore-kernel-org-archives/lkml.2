Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab1FISz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:55:26 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:20200 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1FISzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:55:22 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF11715.5030001@freescale.com>
Date: Thu, 9 Jun 2011 13:55:17 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linuxppc-dev@lists.ozlabs.org>, <alan@lxorguk.ukuu.org.uk>,
        <kumar.gala@freescale.com>, <benh@kernel.crashing.org>,
        <greg@kroah.com>, <akpm@kernel.org>, <cmetcalf@tilera.com>,
        <konrad.wilk@oracle.com>, <dsaxena@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <201106090929.23671.arnd@arndb.de>
In-Reply-To: <201106090929.23671.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Then get rid of all the code that takes apart the ioctl command numbers
> again and just do a switch/case based on the command.

I still need to keep that code to maintain binary compatibility with existing
applications that pass the union as a parameter.

I'll fix that after we've updated the applications.  But we have a
chicken-or-the-egg problem where we need the same application to work with the
new and old ioctl interface for a period of time.

-- 
Timur Tabi
Linux kernel developer at Freescale

