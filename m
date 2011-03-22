Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1CVM71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 08:59:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51102 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1CVM7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 08:59:25 -0400
Date: Tue, 22 Mar 2011 12:59:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sound] !CONFIG_REGULATOR + CONFIG_SND_SOC_ALL_CODECS  ->
	CONFIG_SND_SOC_SGTL5000=m -> build failure
Message-ID: <20110322125923.GA2202@sirena.org.uk>
References: <1300767919.7483.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300767919.7483.6.camel@marge.simson.net>
X-Cookie: I smell a RANCID CORN DOG!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 05:25:19AM +0100, Mike Galbraith wrote:
> v2.6.38-6671-geddecbb
> 
> marge:/usr/local/src/kernel/linux-2.6.39.git # make -j4 && make modules_install install

A patch has been sent for this.

When sending patches or problem reports please always make some effort
to include relevant maintainers and relevant patch authors in your mail.
Mail sent only to a list, particularly a list not relevant to the
affected code, is likely to get missed.
