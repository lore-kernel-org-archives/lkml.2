Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2DPO0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:26:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51468 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab2DPO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:26:29 -0400
Date: Mon, 16 Apr 2012 15:26:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org
Subject: Re: [rtc-linux] Re: [REGRESSION] rtc/interface.c: kills
 suspend-to-ram
Message-ID: <20120416142623.GB6253@sirena.org.uk>
References: <4F8BA1C1.4030804@teksavvy.com>
 <4F8C24E5.4020703@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F8C24E5.4020703@teksavvy.com>
X-Cookie: BOFH excuse
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 09:55:49AM -0400, Mark Lord wrote:

> Can somebody show me how to identify the commit from the code?
> I know which lines got changed, but don't know how to find
> the corresponding commits in -git.

git annotate is usually pretty helpful for this.
