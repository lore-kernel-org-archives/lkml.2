Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab1K2KMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 05:12:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33061 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1K2KMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 05:12:51 -0500
Date: Tue, 29 Nov 2011 10:12:48 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, drivers@analog.com, stable@kernel.org
Subject: Re: [PATCH v2 1/7] firmware: Sigma: Prevent out of bounds memory
 access
Message-ID: <20111129101247.GA2851@opensource.wolfsonmicro.com>
References: <1322469860-8210-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322469860-8210-1-git-send-email-lars@metafoo.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 09:44:14AM +0100, Lars-Peter Clausen wrote:

> Mark, in case you are ok with these patches could you take them through your
> ASoC tree? The firmware subsystem is orphaned.

Yeah, I was planning to do that but I was waiting for Mike to be happy
with everything as he'd had a few concerns on the previous round.  He's
now acked some but not all of the series but there was no followup on
the other patches - Mike, are you OK with the other changes?
