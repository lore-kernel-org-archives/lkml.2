Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab2JPR6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:58:24 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:46035 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932097Ab2JPR6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:58:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rBIb37kRa9rvby8CTJxbG
Date: Tue, 16 Oct 2012 10:58:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastien Guiriec <s-guiriec@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] OMAP4: devices: fixup OMAP4 DMIC platform device error
 message
Message-ID: <20121016175817.GY15569@atomide.com>
References: <1350401440-9620-1-git-send-email-s-guiriec@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350401440-9620-1-git-send-email-s-guiriec@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastien Guiriec <s-guiriec@ti.com> [121016 08:32]:
> Correct DMIC hwmod lockup error message and replace printk() by
> pr_err().

Thanks applying into omap-for-v3.7-rc1/fixes-part2.

Regards,

Tony
