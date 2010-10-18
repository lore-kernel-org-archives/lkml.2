Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab0JRV6k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:58:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47667 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab0JRV6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:58:39 -0400
Date: Mon, 18 Oct 2010 22:58:15 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Nicolas Pitre <nico@fluxnic.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: Re: linux-next: manual merge of the msm tree with the arm tree
Message-ID: <20101018215815.GC23642@flint.arm.linux.org.uk>
References: <20101018103540.7bd9c535.sfr@canb.auug.org.au> <20101018110207.131b56ee.sfr@canb.auug.org.au> <20101018081520.GA10551@flint.arm.linux.org.uk> <1287422792.4105.14.camel@c-dwalke-linux.qualcomm.com> <20101018182044.GA558@flint.arm.linux.org.uk> <1287427572.4105.22.camel@c-dwalke-linux.qualcomm.com> <alpine.LFD.2.00.1010181525000.2764@xanadu.home> <1287432774.5588.5.camel@c-dwalke-linux.qualcomm.com> <20101018205847.GB23642@flint.arm.linux.org.uk> <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287437362.5588.57.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:29:22PM -0700, Daniel Walker wrote:
> That's why we have get_maintainer.pl, it adds in all the CC's
> automatically ..

$ git diff-tree -u 861bd81ee62a0d6759144c22909a8a3938951656 | scripts/get_maintainer.pl |wc 
    209     624    8021

209 recipients / 8K of To:/CC: is reasonable?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
