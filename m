Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab1DJNhs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 09:37:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33300 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab1DJNho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 09:37:44 -0400
Date: Sun, 10 Apr 2011 14:37:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: wanlong.gao@gmail.com
Cc: geert@linux-m68k.org, starvik@axis.com, jesper.nilsson@axis.com,
        sameo@linux.intel.com, ian@opensource.wolfsonmicro.com,
        dp@opensource.wolfsonmicro.com, lrg@slimlogic.co.uk,
        James.Bottomley@suse.de, aelder@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.39-rc2:Removed the unused variable for build
	warnings
Message-ID: <20110410133736.GB1046@sirena.org.uk>
References: <1302368117-32350-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302368117-32350-1-git-send-email-wanlong.gao@gmail.com>
X-Cookie: Preserve the old, but know the new.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 10, 2011 at 12:55:17AM +0800, wanlong.gao@gmail.com wrote:

>  drivers/regulator/wm831x-dcdc.c    |    2 --

This one is fixed already.  In general you should send separate patches
for individual subsystems for things like this in order to avoid merge
issues with overlapping fixes or changes.
