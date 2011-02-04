Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1BDUKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:10:38 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34935 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1BDUKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:10:37 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/vFSRHVIWPuaiQxGQrerNR
Date: Fri, 4 Feb 2011 12:10:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, security@kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/20] mach-omap2: pm: world-writable debugfs timer
 files
Message-ID: <20110204201013.GC3322@atomide.com>
References: <cover.1296818921.git.segoon@openwall.com>
 <aabede4db6c913bc7ab7c289d09eb272594e2290.1296818921.git.segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aabede4db6c913bc7ab7c289d09eb272594e2290.1296818921.git.segoon@openwall.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vasiliy Kulikov <segoon@openwall.com> [110204 04:21]:
> Don't allow all users to change timer settings.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  Cannot compile the driver, so it is not tested at all.

Taking this one too.

Tony
