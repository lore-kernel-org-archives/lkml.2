Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512Ab0GUM7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 08:59:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36023 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0GUM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 08:59:48 -0400
Date: Wed, 21 Jul 2010 13:59:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] mmotm 2010-07-19 - more pm_qos woes - audio this
	time
Message-ID: <20100721125939.GB10930@sirena.org.uk>
References: <201007200007.o6K07Xbg028863@imap1.linux-foundation.org> <62037.1279716892@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62037.1279716892@localhost>
X-Cookie: He who laughs last didn't get the joke.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 08:54:52AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 19 Jul 2010 16:38:09 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-07-19-16-37 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/

> I've accumulated about 1,000 of these overnight. Seems to be consistently landing in
> pairs based on the timestamps.

This looks like a problem I already reported to James, there's a fix
from him in -next already (folded into the original patch).  It was a
generic problem in the PM QoS stuff when CONFIG_DEBUG_PI_LIST was
selected.  See linux-pm for the discussion.
