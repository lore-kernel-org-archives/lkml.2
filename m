Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2G3QBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 12:01:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39237 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab2G3QBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 12:01:48 -0400
X-Sasl-enc: 2XDWUrRMXMcSgtJ4YrfqKGPf6ljf4Ssbwqy9+wgF/uAV 1343664107
Date: Mon, 30 Jul 2012 09:01:46 -0700
From: Greg KH <greg@kroah.com>
To: Singh Sandeep-B37400 <B37400@freescale.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2/3][PATCH][v2] TDM Framework
Message-ID: <20120730160146.GB28703@kroah.com>
References: <1343397940-12975-1-git-send-email-sandeep@freescale.com>
 <20120727152542.GB1613@electric-eye.fr.zoreil.com>
 <3F1D9DCAAB49B94D88DBE05911FA4E6E511121@039-SN1MPN1-006.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3F1D9DCAAB49B94D88DBE05911FA4E6E511121@039-SN1MPN1-006.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2012 at 09:50:57AM +0000, Singh Sandeep-B37400 wrote:
> 1. You should send some kernel mode TDM clients. Without those the framework
>    is pretty useless.
> [Sandeep] We do have a test client but not good enough to be pushed in
> open source, should we add it to documentation?? 

Then how do you know if the framework is "correct" and good enough for
real clients?  We don't add frameworks, or apis, to the kernel without
users, so you will have to come up with some users before we can accept
it.

greg k-h
