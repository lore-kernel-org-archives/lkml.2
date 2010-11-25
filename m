Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab0KYVpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:45:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0KYVpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:45:09 -0500
Date: Thu, 25 Nov 2010 22:45:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Joe Perches <joe@perches.com>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid: hidpidff: Use pr_<level>
In-Reply-To: <1290525880.28824.17.camel@Joe-Laptop>
Message-ID: <alpine.LNX.2.00.1011252244350.981@pobox.suse.cz>
References: <1290497701.28824.6.camel@Joe-Laptop>  <alpine.LNX.2.00.1011231336420.18801@pobox.suse.cz> <1290525880.28824.17.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010, Joe Perches wrote:

> > > Prefixes were not standardized in this module.
> > > Some used "hid-pidff:", others "hidpidff:".
> > > Add pr_fmt(fmt) KBUILD_MODNAME ": " fmt to standardize prefix uses.
> > Hmm, how about using dev_dbg instead? So that we get the bonus of having 
> > the device name there for free?
> 
> Too much restructuring required.
> There's no device available in many of the pr_debug uses.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
