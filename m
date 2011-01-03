Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab1ACKsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:48:25 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52572 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1ACKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:48:24 -0500
Date: Mon, 3 Jan 2011 10:47:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jochen Friedrich <jochen@scram.de>
Cc: linux-arm-kernel@lists.infradead.org, kristoffer.ericson@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37 RESEND] sa1100: Fix platform device registration
Message-ID: <20110103104747.GG26785@n2100.arm.linux.org.uk>
References: <1293472170-14130-1-git-send-email-jochen@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293472170-14130-1-git-send-email-jochen@scram.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 06:49:30PM +0100, Jochen Friedrich wrote:
> Since commit 7a5b4e16c880f8350d255dc188f81622905618c1, simpad devices don't
> boot anymore, since platform devices are registered too early. Fix by moving
> the registration from map_io to arch_initcall as done on other sa1100 boards.

Please send to the patch system, thanks.
