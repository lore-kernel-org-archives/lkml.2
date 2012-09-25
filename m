Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2IYTVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:21:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58834 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882Ab2IYTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:20:51 -0400
Date: Tue, 25 Sep 2012 20:20:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ciminaghi@gnudd.com
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] sta2x11-mfd : add apb-soc regs driver and factor
 out common code
Message-ID: <20120925192048.GA17038@sirena.org.uk>
References: <1347445374-32140-1-git-send-email-ciminaghi@gnudd.com>
 <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347445374-32140-2-git-send-email-ciminaghi@gnudd.com>
X-Cookie: Where does it go when you flush?
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 12:22:47PM +0200, ciminaghi@gnudd.com wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> A driver for the apb-soc registers is needed by the clock
> infrastructure code to configure and control clocks on the sta2x11
> chip.
> Since some of the functions in sta2x11-mfd.c were almost identical
> for the two existing platform devices, the following changes
> have been performed to avoid further code duplication while
> adding the apb-soc-regs driver:

Glancing at the diff here this looks a lot like regmap-mmio...  not sure
if it is or not, though.
