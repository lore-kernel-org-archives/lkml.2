Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1ECRPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:15:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34568 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ECRPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:15:42 -0400
Date: Tue, 3 May 2011 18:15:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Intel SST driver update
Message-ID: <20110503171538.GH2893@sirena.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 05:31:17PM +0100, Alan Cox wrote:
> This is a forward port of various further Intel work on the SST driver in
> staging. This keeps the staging driver up to date while the ALSA driver
> development continues.

What's the plan for moving these out of staging?  Quite a few of these
patches feel like moves in the wrong direction, adding more code that's
going to have problems with mainline rather than addressing the issues
that prevent merges.
