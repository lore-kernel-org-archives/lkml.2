Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1DKWHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 18:07:03 -0400
Received: from netgear.net.ru ([195.178.208.66]:41693 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755356Ab1DKWHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 18:07:01 -0400
Date: Tue, 12 Apr 2011 02:06:57 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Eric B Munson <emunson@mgebm.net>
Cc: Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
        dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, gregkh@suse.de,
        ksrinivasan@novell.com, NetDev <netdev@vger.kernel.org>
Subject: Re: 2.6.39-rc2 boot crash
Message-ID: <20110411220657.GB5783@ioremap.net>
References: <20110406184753.GA7691@mgebm.net>
 <1302115953.8094.217.camel@nimitz>
 <20110406212041.GA2596@mgebm.net>
 <20110406.142157.68145422.davem@davemloft.net>
 <20110406220512.GA2460@mgebm.net>
 <4D9D9AA4.6060304@trash.net>
 <20110411210746.GA2453@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411210746.GA2453@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, Apr 11, 2011 at 05:07:47PM -0400, Eric B Munson (emunson@mgebm.net) wrote:
> > I can't figure this out, the only thing that should have changed is the
> > time the initial PROC_CN_MCAST_LISTEN message is received. Apparently
> > at that point connector is not fully initialized yet. Please post your
> > config and the full boot log. Thanks.
> > 
> 
> I am still seeing this on Linus' tree, is there anything more I can do to help
> track the problem?

Patrick, do you need my assist on this bug?

-- 
	Evgeniy Polyakov
