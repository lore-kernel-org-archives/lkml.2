Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab0LFUwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:52:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49491 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0LFUwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:52:49 -0500
Date: Mon, 6 Dec 2010 20:52:17 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] msm: Secure Channel Manager (SCM) support
Message-ID: <20101206205217.GJ31777@n2100.arm.linux.org.uk>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-2-git-send-email-johlstei@codeaurora.org> <29863.1291665648@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29863.1291665648@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 03:00:48PM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 05 Dec 2010 23:16:14 PST, Jeff Ohlstein said:
> 
> > SCM is the protocol used to communicate between the secure and
> > non-secure code executing on the applications processor. 
> 
> Does the presence of SCM hardware imply SMP?  From reading this, it's unclear
> why the dependence on SMP - it looks like scm.c is something that hardware that
> has one ARM processor and a 'secure processor' would still want.  Or is the
> 'secure processor' just another (arbitrarily labeled) ARM CPU participating
> as a full SMP processor?

It's referring to the secure mode, which is a separate address space and
system running on the same CPU.
