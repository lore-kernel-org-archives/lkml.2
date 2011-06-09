Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab1FIQgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:36:49 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:40563
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab1FIQgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:36:46 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DF0F672.8040206@freescale.com>
Date: Thu, 9 Jun 2011 11:36:02 -0500
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
References: <1307573154-15838-1-git-send-email-timur@freescale.com> <20110608161009.7b05d305.randy.dunlap@oracle.com> <201106090938.23027.arnd@arndb.de> <4DF0F5A1.5080008@oracle.com>
In-Reply-To: <4DF0F5A1.5080008@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> But it sounds like virt/ needs virt/host/ and virt/guest/ to me.

I'm okay with that idea, except there's a consensus that drivers should be in
drivers/.

-- 
Timur Tabi
Linux kernel developer at Freescale

