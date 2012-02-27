Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2B0JnT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:43:19 -0500
Received: from mail.southpole.se ([193.12.106.18]:57702 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2B0JnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:43:18 -0500
Message-ID: <1330335808.16647.92.camel@crucifix>
Subject: Re: [PATCH 1/2] irq_domain: Centralize definition of
 irq_dispose_mapping()
From: Jonas Bonn <jonas@southpole.se>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux@openrisc.net
Date: Mon, 27 Feb 2012 10:43:28 +0100
In-Reply-To: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
References: <1330102448-19172-1-git-send-email-grant.likely@secretlab.ca>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 35790-05538
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2012-02-24 at 09:54 -0700, Grant Likely wrote:
> Several architectures define their own empty irq_dispose_mapping().  Since
> the irq_domain code is centralized now, there is little need to do so.  This
> patch removes them and creates a new empty copy when !CONFIG_IRQ_DOMAIN is
> selected.
> 
> The patch also means that IRQ_DOMAIN becomes selectable on all architectures.

Acked-by: Jonas Bonn <jonas@southpole.se> (for OpenRISC)

