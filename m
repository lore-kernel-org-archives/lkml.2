Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab0EGN14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:27:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40475 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0EGN1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:27:55 -0400
Date: Fri, 7 May 2010 14:27:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: platform_bus: Allow runtime PM by default
Message-ID: <20100507132746.GA3425@sirena.org.uk>
References: <1269625370-17754-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201004231840.20041.rjw@sisk.pl> <201004232026.37114.rjw@sisk.pl> <201004232041.42064.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004232041.42064.rjw@sisk.pl>
X-Cookie: Put no trust in cryptic comments.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 08:41:41PM +0200, Rafael J. Wysocki wrote:

> Jean, the patch we're discussing depends on the
> "i2c: Fix bus-level power management callbacks" patch that's in your tree right
> now.  Would it be possible to move the i2c patch to my tree, or alternatively
> would it be acceptable for you to merge a core PM patch through your tree?

Jean, any updates on this?
