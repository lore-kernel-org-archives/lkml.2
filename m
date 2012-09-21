Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2IUAJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:09:27 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:34721 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756500Ab2IUAJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:09:25 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182GkGrMj0RydJt8gIoUSuS
Date: Thu, 20 Sep 2012 17:09:22 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: Re: [PATCH 1/3] pinctrl: pinctrl-single must be initialized early.
Message-ID: <20120921000922.GQ28835@atomide.com>
References: <1348070841-23354-1-git-send-email-panto@antoniou-consulting.com>
 <1348070841-23354-2-git-send-email-panto@antoniou-consulting.com>
 <20120918182150.GY11762@atomide.com>
 <B7D59159-4456-468B-A414-9B57BCEE018D@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B7D59159-4456-468B-A414-9B57BCEE018D@antoniou-consulting.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pantelis Antoniou <panto@antoniou-consulting.com> [120918 12:11]:
> 
> As long as we get the regulator to work early in the game no problem.
> I don't know if deferring the probe will work in this case.
> I could give it a shot and see if it works at all.

Did you have any luck with deferred probe here?

Tony
