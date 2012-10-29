Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389Ab2J2Scp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:32:45 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:37955 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760372Ab2J2Scm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:32:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <1351028756-22309-1-git-send-email-swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
References: <1351028756-22309-1-git-send-email-swarren@wwwdotorg.org>
Message-ID: <20121029183233.18780.11964@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [RFC PATCH] dt: describe base reset signal binding
Date: Mon, 29 Oct 2012 11:32:33 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2012-10-23 14:45:56)
> What do people think of this? Does it sound like a good idea to go ahead
> with a reset subsystem? Should we simply add a new API to the common clock
> subsystem instead (and assume that reset and clock domains match 1:1).
> Should this be implemented as part of the generic power management domains;
> see include/linux/pm_domain.h instead?
> 

Hi Stephen,

I'm not sure a "reset subsystem" is necessary, but I also do not like
using clocks as the keys for IP reset.  I think it is more common to map
IPs to struct device, no?

And of course for clocks shared by multiple users this will not scale.

Regards,
Mike
