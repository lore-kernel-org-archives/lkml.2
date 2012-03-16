Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161895Ab2CPAzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:55:51 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:57138 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161704Ab2CPAzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:55:49 -0400
Message-ID: <1331859345.2424.38.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] Replace IS_ENABLED(CONFIG_FCOE) in linux/netdevice.h
From: Ben Hutchings <bhutchings@solarflare.com>
To: Tony Breeds <tony@bakeyournoodle.com>
CC: Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, <devel@open-fcoe.org>,
        <netdev@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 16 Mar 2012 00:55:45 +0000
In-Reply-To: <1331857815-2333-1-git-send-email-tony@bakeyournoodle.com>
References: <1331857815-2333-1-git-send-email-tony@bakeyournoodle.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18774.005
X-TM-AS-Result: No--13.466500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 11:30 +1100, Tony Breeds wrote:
> On platforms that (or configs that do not have PCI support building any
> code that includes linux/netdevice.h we see the following warnings:
> 
> include/linux/netdevice.h:964:1: warning: "__enabled_CONFIG_FCOE" is not defined [-Wundef]
> include/linux/netdevice.h:964:1: warning: "__enabled_CONFIG_FCOE_MODULE" is not defined [-Wundef]
> 
> In the case of this file we can trivially fallback to the old school
>  #if defined(...) syntax.
[...]

The script that generates those symbols should be fixed instead.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

