Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730Ab1JYQBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:01:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37504 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1JYQBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:01:19 -0400
Date: Tue, 25 Oct 2011 17:01:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kyle Manna <kyle.manna@fuel7.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2 1/6] mfd: TPS65910: Handle non-existent devices
Message-ID: <20111025160117.GA634@sirena.org.uk>
References: <1319475964-10841-1-git-send-email-kyle.manna@fuel7.com>
 <1319475964-10841-2-git-send-email-kyle.manna@fuel7.com>
 <20111025071417.GE2919@opensource.wolfsonmicro.com>
 <4EA6D14D.6060800@fuel7.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA6D14D.6060800@fuel7.com>
X-Cookie: diplomacy, n:
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:10:05AM -0500, Kyle Manna wrote:
> On 10/25/2011 02:14 AM, Mark Brown wrote:

> >Can you check for a known value in any of the registers?

> Unfortunately on this chip there aren't any identification or
> constant test registers.  The only register close is the
> JTAGVERNUM_REG and that's will change across silicon revisions.

It seems like a more useful implementation would be to have the driver
read and display this revision number during boot, this will give you
the register readability check and also let us know the device revision
which might be useful for diagnostics.
