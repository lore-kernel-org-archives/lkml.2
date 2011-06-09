Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab1FIQs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:48:58 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:9748
	"EHLO CH1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753038Ab1FIQsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:48:55 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF0F973.6050008@freescale.com>
Date: Thu, 9 Jun 2011 11:48:51 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linuxppc-dev@lists.ozlabs.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        <konrad.wilk@oracle.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <cmetcalf@tilera.com>,
        <akpm@kernel.org>, <dsaxena@linaro.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 7/7] [v4] drivers/virt: introduce Freescale hypervisor
 management driver
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com> <201106090938.23027.arnd@arndb.de> <4DF0F5A1.5080008@oracle.com> <4DF0F672.8040206@freescale.com> <4DF0F7F5.5050107@oracle.com>
In-Reply-To: <4DF0F7F5.5050107@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
>> > I'm okay with that idea, except there's a consensus that drivers should be in
>> > drivers/.
>> > 
> Like sound/ ?

My understanding is that this is something that's considered broken and should
be fixed, but I don't know what the holdup is.

> but what makes it a "driver"?

That's a good point.

Ok, so maybe I don't have any really good answers here. :-)

-- 
Timur Tabi
Linux kernel developer at Freescale

