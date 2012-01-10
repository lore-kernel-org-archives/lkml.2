Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab2AJWnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:43:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46829 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920Ab2AJWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:43:31 -0500
Date: Tue, 10 Jan 2012 22:43:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>, "arnd@arndb.de" <arnd@arndb.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 02/06] MFD: DA9052/53 MFD core module v9 Added ADC
	support
Message-ID: <20120110224329.GM7164@opensource.wolfsonmicro.com>
References: <1326098770.3542.31.camel@dhruva> <20120109223725.GG30766@opensource.wolfsonmicro.com> <C3AE124F08223B42BC95AEB82F0F6CED1FDB2D4E@KCHJEXMB02.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3AE124F08223B42BC95AEB82F0F6CED1FDB2D4E@KCHJEXMB02.kpit.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 05:50:30AM +0000, Ashish Jangam wrote:

> >>This is patch 2/6 - where are patches 1 and 3-6?

> Patch 1 and 3-6 are already ACK'ed and got merged.
> Since patch 2/6 was not merged therefore got re-submitted.

You're not understanding the purpose of the numbering at all here.  The
numbering is there so that people know what order the patches being sent
together come in.  If a patch has been sent before as part of a series
that's totally irrelevant to a further submission.

If you label the patch as part of a series like this then you're saying
that there's a patch 1 that this depends on and is needed for this to be
applied.
