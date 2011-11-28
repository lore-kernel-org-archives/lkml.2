Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1K1WcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:32:10 -0500
Received: from d1.icnet.pl ([212.160.220.21]:38756 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796Ab1K1WcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:32:08 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 4/5] init/calibrate.c: allow for recalibration of loops per jiffy
Date: Mon, 28 Nov 2011 23:30:45 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        linux-kernel@vger.kernel.org, Sameer Nanda <snanda@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1322364751-29980-1-git-send-email-jkrzyszt@tis.icnet.pl> <1322364751-29980-5-git-send-email-jkrzyszt@tis.icnet.pl> <20111128153900.GA16481@n2100.arm.linux.org.uk>
In-Reply-To: <20111128153900.GA16481@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201111282330.46015.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 of November 2011 at 16:39:00, Russell King - ARM Linux wrote:
> On Sun, Nov 27, 2011 at 04:32:30AM +0100, Janusz Krzysztofik wrote:
> > This is required on ARM OMAP1 platform, after DPLL reprogramming has
> > been fixed by moving it from setup_arch() to kernel_init().
> > 
> > Created against linux-3.2-rc2.
> 
> Why do you need this?  If you know what the original CPU clock rate and
> bogomips were, and the new CPU clock rate, then you simply scale the
> bogomips from the original accordingly.  That's what cpufreq does.

Hi,
Please ignore this patch. I'm going to post a replacement for patch 5/5 
which, thanks to Russell's help, will no longer require any changes in 
init/calibrate.c.

Russell,
Thanks for pointing me into the right direction.

Janusz
