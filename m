Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1ECQ6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:58:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53803 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896Ab1ECQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:58:43 -0400
Date: Tue, 3 May 2011 17:58:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/23] intel_sst: MSIC codec power optimisation
Message-ID: <20110503165838.GF2893@sirena.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk> <20110503163200.24853.6842.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503163200.24853.6842.stgit@bob.linux.org.uk>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 05:32:01PM +0100, Alan Cox wrote:

> From: Vinod Koul <vinod.koul@intel.com>
> 
> This patch adds power optimization for the msic codec and ensure
> codec is completely powered off when codec is idle.

Once you move over to proper CODEC drivers the core will take care of
this stuff for you.
