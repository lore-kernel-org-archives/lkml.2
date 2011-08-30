Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1H3OuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 10:50:07 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:37970 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1H3OuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 10:50:06 -0400
Date: Tue, 30 Aug 2011 10:49:55 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110830104955.4b1b8381@v0nbox>
In-Reply-To: <20110830110020.GE2061@opensource.wolfsonmicro.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110829221132.GB26846@sirena.org.uk>
	<4E5C76E0.4000008@zytor.com>
	<20110830110020.GE2061@opensource.wolfsonmicro.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Aug 2011 12:00:20 +0100,
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Mon, Aug 29, 2011 at 10:36:32PM -0700, H. Peter Anvin wrote:
> > On 08/29/2011 03:11 PM, Mark Brown wrote:
> 
> > > New GPIO drivers should really go under drivers/gpiolib and be
> > > called gpio-foo.c.
> 
> > Should they?  It seems a lot more reasonable to have them collected
> > by platform than by type of device (GPIO), *unless* they are shared.

Grouping every driver for this platform was one of the main comments of
my first RFC set of patches. And indeed, the GPIO driver is really
specific to this platform, so it won't be shared.

	Vivien.
> 
> There was some discussion of this, mostly for ARM, the general
> conclusion being that sharing the code improves visibility of things
> for the subsystem maintainer, ensures that the code gets reviewed (and
> updated if things change) by subsystem experts and makes it more
> likely that where there are things that can be shared someone will
> notice.
