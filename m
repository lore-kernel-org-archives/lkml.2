Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2FZLvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:51:39 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:1268 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755268Ab2FZLvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:51:37 -0400
Message-ID: <1340711491.2197.16.camel@x61.thuisdomein>
Subject: Re: [PATCH] OMAP7XX:  Remove omap730.h and omap850.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 13:51:31 +0200
In-Reply-To: <20120626112524.GF31393@atomide.com>
References: <1340013485.5611.6.camel@x61.thuisdomein>
	 <20120626112524.GF31393@atomide.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Jun 2012 11:51:32.0550 (UTC) FILETIME=[07D76660:01CD5392]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-26 at 04:25 -0700, Tony Lindgren wrote:
> * Paul Bolle <pebolle@tiscali.nl> [120618 03:02]: 
> > 1) A related cleanup could be to remove cpu_is_omap730 and
> > cpu_is_omap850, as both macros seem unused.
> 
> Yes seems like we could do that. Care to do a patch for that?

Sure, no problem. I hope to submit it shortly.


Paul Bolle

