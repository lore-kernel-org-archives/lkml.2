Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0C3OMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:12:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48155 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0C3OMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:12:05 -0400
Date: Tue, 30 Mar 2010 15:12:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add WM8994 interrupt controller support
Message-ID: <20100330141201.GA17007@sirena.org.uk>
References: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269894525-21530-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 09:28:45PM +0100, Mark Brown wrote:

> +	printk(KERN_CRIT "%x %x\n", status[0], status[1]);

Clearly this is debug code and shouldn't be there in an actual version.
I'll remove this when resubmitting after review & merge path are sorted
out.
