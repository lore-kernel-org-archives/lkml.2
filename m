Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1FFPsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:48:14 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:41459
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab1FFPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:48:12 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h8e3h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DECF6B3.5020700@freescale.com>
Date: Mon, 6 Jun 2011 10:48:03 -0500
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
References: <1306953337-15698-1-git-send-email-timur@freescale.com> <201106031724.44957.arnd@arndb.de> <4DE8FD85.7000703@freescale.com> <201106061742.01974.arnd@arndb.de>
In-Reply-To: <201106061742.01974.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Sorry, I misread your first sentence above. I thought you said that you prefer
> drivers/firmware over virt/fsl. drivers/misc is definitely the wrong
> place for this, please choose a better one. Maybe drivers/virt/ ?

I'll be more than happy to go with the consensus, but I don't think it makes
sense to create a new directory just for this one, limited-use driver.  You're
the only person who's complained about drivers/misc.  I'm pretty sure that if I
put it in drivers/virt, I'll get more complaints.

I still don't understand what's wrong with drivers/misc, especially since my
driver registers as a "misc" driver.

-- 
Timur Tabi
Linux kernel developer at Freescale

