Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab2BTHdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 02:33:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52771 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2BTHdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 02:33:21 -0500
Date: Mon, 20 Feb 2012 07:33:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ryan Mallon <rmallon@gmail.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/18] ARM: at91: make ST (System Timer) soc independent
Message-ID: <20120220073301.GA22562@n2100.arm.linux.org.uk>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com> <957702b1ff83afcc0a8e842f53f05ff3f40b78b3.1329500622.git.nicolas.ferre@atmel.com> <4F419246.6080405@gmail.com> <20120220013825.GD29599@game.jcrosoft.org> <4F41A76D.1070409@gmail.com> <20120220030234.GE29599@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220030234.GE29599@game.jcrosoft.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 04:02:34AM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 12:52 Mon 20 Feb     , Ryan Mallon wrote:
> > That isn't an excuse to leave incorrect code there. It is a simple fix.
> no (void) in c means you don't care of the return so basically it's right

Let's be clear: it's legal, but redundant and unnecessary.
