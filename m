Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0GNOSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 10:18:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51045 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753465Ab0GNOSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 10:18:30 -0400
Date: Wed, 14 Jul 2010 15:18:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Christian Dietrich <stettberger@dokucode.de>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
        Rajendra Nayak <rnayak@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 1/5] drivers/regulator: Remove dead
 CONFIG_TWL4030_ALLOW_UNSUPPORTED
Message-ID: <20100714141828.GD31073@rakim.wolfsonmicro.main>
References: <c3c850bed3f5714f1efcfad24ad4f8bfcb6b5b54.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
 <20100714141108.GC31073@rakim.wolfsonmicro.main>
 <86fwzmm9m9.fsf@peer.zerties.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fwzmm9m9.fsf@peer.zerties.org>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 04:16:46PM +0200, Christian Dietrich wrote:
> Mark Brown <broonie@opensource.wolfsonmicro.com> writes:

> > Nack, you're missing the point of having this code here.

> So if it isn't a config option, then perhaps it should be named CONFIG_?

I'm assuming you've got the wrong number negations there, but possibly.
Really it ought to be platform data I guess.
