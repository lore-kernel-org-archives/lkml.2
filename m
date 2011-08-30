Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1H3LAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:00:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51456 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753021Ab1H3LAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:00:22 -0400
Date: Tue, 30 Aug 2011 12:00:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
Message-ID: <20110830110020.GE2061@opensource.wolfsonmicro.com>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110829221132.GB26846@sirena.org.uk>
 <4E5C76E0.4000008@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5C76E0.4000008@zytor.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 10:36:32PM -0700, H. Peter Anvin wrote:
> On 08/29/2011 03:11 PM, Mark Brown wrote:

> > New GPIO drivers should really go under drivers/gpiolib and be called
> > gpio-foo.c.

> Should they?  It seems a lot more reasonable to have them collected by
> platform than by type of device (GPIO), *unless* they are shared.

There was some discussion of this, mostly for ARM, the general
conclusion being that sharing the code improves visibility of things for
the subsystem maintainer, ensures that the code gets reviewed (and
updated if things change) by subsystem experts and makes it more likely
that where there are things that can be shared someone will notice.
