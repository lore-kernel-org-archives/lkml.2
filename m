Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1KJXoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:44:17 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37516 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab1KJXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:44:15 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19SAdb/DSIvAU3BSQYPcR3I
Date: Thu, 10 Nov 2011 15:44:12 -0800
From: Tony Lindgren <tony@atomide.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/16] ARM: LPAE: Move the FSR definitions to
 separate files
Message-ID: <20111110234411.GC31337@atomide.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
 <1320682618-1182-5-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320682618-1182-5-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Catalin Marinas <catalin.marinas@arm.com> [111107 07:59]:
> +	{ do_bad,		SIGBUS,  0,		"unknown 29"			   },
> +	{ do_bad,		SIGBUS,  0,		"unknown 30"			   },
> +	{ do_bad,		SIGBUS,  0,		"unknown 31"			   }

Maybe add the trailing comma here while at it? :)

Regards,

Tony
