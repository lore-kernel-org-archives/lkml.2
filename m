Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2A1RZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 12:25:38 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36558 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753333Ab2A1RZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 12:25:37 -0500
Message-ID: <4F243D2C.7040709@xenotime.net>
Date: Sat, 28 Jan 2012 10:23:40 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v3 01/25] irq_domain: add documentation and MAINTAINERS
 entry.
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <1327700179-17454-2-git-send-email-grant.likely@secretlab.ca>
In-Reply-To: <1327700179-17454-2-git-send-email-grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 01:35 PM, Grant Likely wrote:
> Documentation for irq_domain library which will be created in subsequent
> patches.

I posted a lot of comments to v2 on Jan. 24.
Looks like they were ignored.

Please see  http://marc.info/?l=linuxppc-embedded&m=132742951211808&w=2


> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Milton Miller <miltonm@bga.com>
> ---
>  Documentation/IRQ-domain.txt |  113 ++++++++++++++++++++++++++++++++++++++++++
>  MAINTAINERS                  |    9 +++
>  2 files changed, 122 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/IRQ-domain.txt


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
