Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2JDTWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:22:48 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:16140 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756188Ab2JDTWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:22:47 -0400
Message-ID: <1349378563.2817.27.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 08/11] net: ll_temac: Do not use fixed mtu size
From: Ben Hutchings <bhutchings@solarflare.com>
To: Michal Simek <monstr@monstr.eu>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 4 Oct 2012 20:22:43 +0100
In-Reply-To: <1349374497-9540-8-git-send-email-monstr@monstr.eu>
References: <1349374497-9540-1-git-send-email-monstr@monstr.eu>
	 <1349374497-9540-8-git-send-email-monstr@monstr.eu>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 20:14 +0200, Michal Simek wrote:
> Use max mtu instead.
[...]

MTU does not include the Ethernet header so I have no idea how this is
expected to work...

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

