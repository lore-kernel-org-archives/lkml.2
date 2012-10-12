Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759664Ab2JLQ25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:28:57 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:33389 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755465Ab2JLQ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:28:56 -0400
Message-ID: <1350059332.2819.18.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 5/6] net: calxedaxgmac: rework transmit ring handling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jonathan@jonmasters.org>, <eric.dumazet@gmail.com>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Date: Fri, 12 Oct 2012 17:28:52 +0100
In-Reply-To: <1350054908-30646-6-git-send-email-robherring2@gmail.com>
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
	 <1350054908-30646-6-git-send-email-robherring2@gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 10:15 -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Only generate tx interrupts on every ring size / 4 descriptors. Move the
> netif_stop_queue call to the end of the xmit function rather than
> checking at the beginning.
[...]

The hardware should also interrupt if the TX ring becomes empty; does it
do that?

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

