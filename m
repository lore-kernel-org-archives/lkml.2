Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab0JRVSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:18:07 -0400
Received: from relais.videotron.ca ([24.201.245.36]:43883 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab0JRVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:18:04 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Mon, 18 Oct 2010 17:17:54 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
In-reply-to: <1287435928.5588.37.camel@c-dwalke-linux.qualcomm.com>
Message-id: <alpine.LFD.2.00.1010181714090.2764@xanadu.home>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au>
 <201010182219.25890.arnd@arndb.de>
 <1287434251.5588.23.camel@c-dwalke-linux.qualcomm.com>
 <201010182248.36078.arnd@arndb.de>
 <1287435928.5588.37.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010, Daniel Walker wrote:

> I guess your assuming I send my pull request after Russell's, which
> isn't necessarily true, and I'd rather not have that dependency if I
> don't have to. 

Look, we're not establishing a straight rule here -- just figuring out a 
way to move forward.  What we're asking you to do is either ask RMK to 
pull your tree now, or wait until RMK's tree has hit mainline so you can 
pull Linus' tree and fix the issue yourself before asking Linus to pull, 
or whatever.  Is some collaboration on your part for this particular 
issue too much to ask for?


Nicolas
