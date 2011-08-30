Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1H3PM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:12:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50662 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754800Ab1H3PMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:12:24 -0400
Date: Tue, 30 Aug 2011 16:12:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110830151218.GJ2061@opensource.wolfsonmicro.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110829221132.GB26846@sirena.org.uk>
 <4E5C76E0.4000008@zytor.com>
 <20110830110020.GE2061@opensource.wolfsonmicro.com>
 <20110830104955.4b1b8381@v0nbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110830104955.4b1b8381@v0nbox>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 10:49:55AM -0400, Vivien Didelot wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> > > Should they?  It seems a lot more reasonable to have them collected
> > > by platform than by type of device (GPIO), *unless* they are shared.

> Grouping every driver for this platform was one of the main comments of
> my first RFC set of patches. And indeed, the GPIO driver is really
> specific to this platform, so it won't be shared.

That's the case for a lot of the ARM ones too, the same considerations
apply there.  There's generally a problem with people working needlessly
in isolation and a fairly low burden for subsystem maintainers.
