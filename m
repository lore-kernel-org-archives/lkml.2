Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab1H2WOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 18:14:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57087 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1H2WOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 18:14:16 -0400
Date: Mon, 29 Aug 2011 23:13:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: x86@kernel.org, Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [v2 4/4] platform: (TS-5500) add ADC support
Message-ID: <20110829221355.GC26846@sirena.org.uk>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-5-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314402027-11293-5-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Cookie: Every morning is a Smirnoff morning.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 07:40:27PM -0400, Vivien Didelot wrote:
> From: Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>
> 
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Would this fit into IIO?  It's still in staging and doesn't really
support system monitoring style ADCs (like those typically used for
thermal or supply voltage measurements) well so perhaps not.
