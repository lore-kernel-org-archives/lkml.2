Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab1AaNgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 08:36:53 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36509 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1AaNgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 08:36:52 -0500
Date: Mon, 31 Jan 2011 13:36:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] soc: neo1973_wm8753 audio support does not require
	scoop
Message-ID: <20110131133648.GG11937@sirena.org.uk>
References: <201101281200.18371.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101281200.18371.hartleys@visionengravers.com>
X-Cookie: To err is humor.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 12:00:18PM -0700, H Hartley Sweeten wrote:
> This driver does not use any of the functionality provided by the scoop
> hardware.  Remove the unneeded header.

Applied but please in future remember to:

- Send copies of your patches to the relevant maintainers as documented
  in Documentation/SubmittingPatches so maintainers actually see them.
- Make your commit messages match the style for the subsystem you're
  submitting to.

This stuff is especially important for minor cleanups like this, please
do try to bear it in mind.
