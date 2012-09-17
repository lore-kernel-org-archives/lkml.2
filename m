Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab2IQNnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:43:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46160 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab2IQNnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:43:47 -0400
Date: Mon, 17 Sep 2012 09:32:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andres Lagar-Cavilla <andreslc@gridcentric.ca>, davem@davemloft.net
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Andres Lagar-Cavilla <andres@lagarcavilla.org>,
        xen-devel <xen-devel@lists.xen.org>,
        David Vrabel <david.vrabel@citrix.com>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] Xen backend support for paged out grant targets V4.
Message-ID: <20120917133234.GB11553@phenom.dumpdata.com>
References: <1347632819-13684-1-git-send-email-andres@lagarcavilla.org>
 <1347869865.14977.15.camel@zakaz.uk.xensource.com>
 <5B5132A4-93B2-41D0-B1A6-048810565DB5@gridcentric.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5B5132A4-93B2-41D0-B1A6-048810565DB5@gridcentric.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Signed-off-by: Andres Lagar-Cavilla <andres@lagarcavilla.org>
> > 
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > 
> > Since this is more about grant tables than netback this should probably
> > go via Konrad rather than Dave, is that OK with you Dave?
> 
> If that is the case hopefully Konrad can deal with the two typos? Otherwise happy to re-spin the patch.

Sure. Just waiting for an Ack from David.
