Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1JPUXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 16:23:01 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:12111 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab1JPUW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 16:22:59 -0400
Date: Sun, 16 Oct 2011 22:22:57 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: crn@netunix.com
Cc: Paul Bolle <pebolle@tiscali.nl>, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/21] sparc: drop unused Kconfig symbol
Message-ID: <20111016202257.GA25970@merkur.ravnborg.org>
References: <1318595257.6132.59.camel@x61.thuisdomein> <alpine.LNX.2.00.1110150111520.26030@post.netunix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1110150111520.26030@post.netunix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 01:14:02AM +0100, crn@netunix.com wrote:
>
> How does this affect Javastations, ISTR that they need PCI and one
> (rare) variant has a PCI slot. ??

It was replaced by a more specific CONFIG_SPARC_PCIC symbol
in commit: cfe3af5dde34a019c1bd2485b1dc0f2d7a326ccd

	Sam
