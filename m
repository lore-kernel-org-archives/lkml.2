Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1DTPXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:23:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28887 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1DTPXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:23:52 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19lXlL5sePITGQ2WYkk7ROc
Date: Wed, 20 Apr 2011 08:23:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: oskar.andero@sonyericsson.com
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm: omap2: enable smc instruction for sleep34xx
Message-ID: <20110420152347.GC10402@atomide.com>
References: <1303224171-24984-1-git-send-email-oskar.andero@sonyericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303224171-24984-1-git-send-email-oskar.andero@sonyericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* oskar.andero@sonyericsson.com <oskar.andero@sonyericsson.com> [110419 07:39]:
> This fixes broken build when using binutils 2.21.

Thanks will queue for the -rc cycle.

Tony
