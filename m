Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1FFQJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:09:47 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:24613 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1FFQJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:09:45 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz1419M98dKzz1202hzzz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DECFBC5.6070205@freescale.com>
Date: Mon, 6 Jun 2011 11:09:41 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Deepak Saxena <dsaxena@linaro.org>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106061742.01974.arnd@arndb.de> <4DECF6B3.5020700@freescale.com> <201106061803.58531.arnd@arndb.de>
In-Reply-To: <201106061803.58531.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> When we talked about the situation of drivers/misc and drivers/char at
> one of the recent conferences, a broad consensus was that they are in
> need of a maintainer, which I foolishly signed up for. Deepak wanted
> to send an update to the MAINTAINERS file for this (I guess I can do
> that too, since he must have forgotten about it), but the main idea is
> that I'm there to say no to any driver that someone tries to add there,
> unless there are really good reasons why it is actually a good place
> to live for that driver.

Can you give me an example of a driver that *does* belong in drivers/misc?
Frankly, I just don't see what's wrong with a repository of various drivers that
don't really belong anywhere else.

And what about my concern that my driver will be the only one in drivers/virt?

-- 
Timur Tabi
Linux kernel developer at Freescale

