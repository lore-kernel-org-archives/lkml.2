Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1KIMNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 07:13:35 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34057 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1KIMNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 07:13:33 -0500
Date: Wed, 9 Nov 2011 12:13:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: Re: Staging clear up
Message-ID: <20111109121329.GC21630@sirena.org.uk>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
X-Cookie: Dr. Jekyll had something to Hyde.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 09:16:56PM +0000, Alan Cox wrote:

> drivers/staging/intel_sst

> This also appears on Medfield but there is an ASoC driver for the
> Medfield version and we no longer need to keep this. There were naughty
> bits of code peeking into staging for files but that should now be sorted
> (and if not they need to break and be forced to fix them)

There was also all the compressed audio offload stuff in there which
is useful but isn't integrated yet.  Vinod posted a version of the
generic compressed API but work seems to have stalled again.
