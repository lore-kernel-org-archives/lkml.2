Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab2HATwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:52:14 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33716 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2HATwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:52:13 -0400
Date: Wed, 1 Aug 2012 20:52:04 +0100
From: Matthew Garrett <mjg@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Andreas Heider <andreas@meetr.de>,
        Arun Raghavan <arun.raghavan@collabora.co.uk>,
        linux-kernel@vger.kernel.org, airlied@redhat.com
Subject: Re: [PATCH] apple-gmux: Restore switch registers on suspend/resume
Message-ID: <20120801195204.GA7251@srcf.ucam.org>
References: <4FFCC7FB.1090609@meetr.de>
 <1343522547.2488.12.camel@shinybook.infradead.org>
 <1343524730.1962.5.camel@shinybook.infradead.org>
 <20120729193953.GA25132@srcf.ucam.org>
 <1343595171.2511.1.camel@shinybook.infradead.org>
 <20120729205859.GA25819@srcf.ucam.org>
 <20120731151856.GA19979@thinkpad-t410>
 <1343835344.26866.150.camel@shinybook.infradead.org>
 <20120801155914.GB22963@thinkpad-t410>
 <1343850238.26866.171.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343850238.26866.171.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 08:43:58PM +0100, David Woodhouse wrote:
> On Wed, 2012-08-01 at 10:59 -0500, Seth Forshee wrote:
> > since there still doesn't seem to be any way
> > to get the vbios for the Intel graphics.
> 
> Hm, wait. With Matthew's patches to get the Radeon BIOS from EFI, there
> *is* also a ROM image for the Intel device. Have we tried that?

There is? Unexpected! The driver ought to be picking that up 
automatically...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
