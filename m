Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1F3WUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 18:20:22 -0400
Received: from ns.penguin.cz ([84.21.108.25]:56204 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1F3WUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 18:20:20 -0400
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
From: Stanislav Brabec <utx@penguin.cz>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
In-Reply-To: <4E0CE189.1020000@compulab.co.il>
References: <1308845380.4533.54.camel@oct.suse.cz>
	 <201106301352.21684.marek.vasut@gmail.com>
	 <1309445118.4406.47.camel@oct.suse.cz> <4E0C957F.8080807@compulab.co.il>
	 <1309450406.4406.59.camel@oct.suse.cz> <4E0CB518.2080703@compulab.co.il>
	 <20110630180105.GA5064@opensource.wolfsonmicro.com>
	 <4E0CE189.1020000@compulab.co.il>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Fri, 01 Jul 2011 00:20:15 +0200
Message-ID: <1309472415.6630.8.camel@utx.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Grinberg wrote:

> Stanislav,
> Can't you define a fixed voltage regulator for the ads7846 in spitz board file?
> This shouldn't be a hard task and is the right solution from the regulator API POV.

Yes, I can.

ADS7846 needs more definitions in the platform file to work well on
spitz. The current platform definition is not sufficient and pointer
noise makes it unusable (e. g. 100 pixels jumps). I am comparing Lineo's
2.4 code with 2.6 algorithm and experimenting to get the best results.

-- 

________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx

