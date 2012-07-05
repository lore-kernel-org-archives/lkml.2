Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2GETPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:15:14 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:54443 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab2GETPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:15:10 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AilUAG/m9U9V5qg+PGdsb2JhbABFihqtFRkBAQEBHgMWDSeCGAEBBToNDyMQCAMYLhQlChqIIqpijwUUiyWFXmADlTaFZoNBiT4
X-IronPort-AV: E=Sophos;i="4.77,532,1336341600"; 
   d="scan'208";a="148783350"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 5 Jul 2012 21:15:39 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>
Subject: Re: [PATCH 04/23 v6] Input: atmel_mxt_ts - warn if sysfs could not
 be created
Message-ID: <20120705191539.GA14454@polaris.bitmath.org>
References: <1340888904-15620-1-git-send-email-djkurtz@chromium.org>
 <1340888904-15620-5-git-send-email-djkurtz@chromium.org>
 <20120705172230.GB31383@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705172230.GB31383@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 10:22:30AM -0700, Dmitry Torokhov wrote:
> Hi Daniel, Henrik,
> 
> On Thu, Jun 28, 2012 at 09:08:05PM +0800, Daniel Kurtz wrote:
> > If sysfs entry creation fails, the driver is still usable, so don't
> > just abort probe.  Just warn and continue.
> > 
> 
> I understand that I am a bit late to the party :) but I do not agree
> with this change. Failure to create attributes is not sometihng that
> user could cause (at least not easily) and thus would not be a setup
> issue but something more severe. I believe we should fail loading the
> driver so sysfs attribute breakage will be noticed as soon as possible,
> instead of discovering it much much later in the process.
> 
> So I think we should revert this one.

Ok, I agree. Applied and pushed.

Daniel, I should probably have asked this before: what was the reason
for this patch in the first place?

Thanks,
Henrik
