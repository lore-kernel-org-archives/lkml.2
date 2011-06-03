Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1FCP2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:28:13 -0400
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:12215
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab1FCP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:28:11 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE8FD85.7000703@freescale.com>
Date: Fri, 3 Jun 2011 10:28:05 -0500
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
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106012340.14237.arnd@arndb.de> <4DE8008E.9030008@freescale.com> <201106031724.44957.arnd@arndb.de>
In-Reply-To: <201106031724.44957.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
>> > I don't think it's correct to think of a hypervisor as firmware, so I don't
>> > think drivers/firmware is better.
>> > 
>> > I'm not sure that creating virt/fsl and putting the driver in there is a good
>> > idea, because it will be the only driver in that directory.  Unlike KVM, this
>> > driver is just a collection of front-ends to our hypervisor API.  The actual
>> > hypervisor is completely separate.  That's why I put it in drivers/misc, because
>> > it's just a single driver with a miscellaneous collection of interfaces.

> Ok, fair enough. If nobody has a strong preference any other way, just make it
> drivers/firmware then.

Did you mean to say drivers/misc?

-- 
Timur Tabi
Linux kernel developer at Freescale

