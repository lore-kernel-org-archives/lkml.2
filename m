Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2KLXVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 18:21:25 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:36488 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752718Ab2KLXVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 18:21:24 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19VCv3iVGN/ztH6ZpRhJIH9
Date: Mon, 12 Nov 2012 15:21:21 -0800
From: Tony Lindgren <tony@atomide.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP1: use BUG_ON where possible
Message-ID: <20121112232120.GX6801@atomide.com>
References: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
 <1352406191-14303-7-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352406191-14303-7-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sasha Levin <sasha.levin@oracle.com> [121108 12:26]:
> Just use BUG_ON() instead of constructions such as:
> 
> 	if (...)
> 		BUG()
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression e;
> @@
> - if (e) BUG();
> + BUG_ON(e);
> // </smpl>
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Thanks applying into omap-for-v3.8/board-v2.

Regards,

Tony
