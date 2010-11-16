Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0KPVjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:39:37 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32249 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab0KPVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:39:36 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.188.36.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+gUK9nGooV3/jYqpwEmTZK
Date: Tue, 16 Nov 2010 13:39:18 -0800
From: Tony Lindgren <tony@atomide.com>
To: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk
Subject: Re: [PATCHv3 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
Message-ID: <20101116213918.GN9264@atomide.com>
References: <cd6fa21776a4564d602cc072358a4bf79a9fe883.1289205105.git.EXT-Eugeny.Kuznetsov@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd6fa21776a4564d602cc072358a4bf79a9fe883.1289205105.git.EXT-Eugeny.Kuznetsov@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com> [101108 00:35]:
> From: Evgeny Kuznetsov <ext-eugeny.kuznetsov@nokia.com>
> 
> Value of "isr_reg" pointer is depend on configuration and GPIO method.
> Potentially it may have NULL value and it is dereferenced later
> in code. Warning and exit from function are added in this case.

Thanks, queueing this for 2.6.38 merge window.

Tony
