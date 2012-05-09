Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2EIH4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 03:56:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47732 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2EIH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 03:56:24 -0400
Date: Wed, 9 May 2012 09:56:18 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] ARM: mx35: add cpufreq support
Message-ID: <20120509075618.GA4412@lovely.krouter>
References: <20120507141437.GA9636@lovely.krouter>
 <20120509072239.GG27341@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509072239.GG27341@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Wed, May 09, 2012 at 09:22:39AM +0200, Sascha Hauer wrote:
> On Mon, May 07, 2012 at 04:14:37PM +0200, Christoph Fritz wrote:
> > This patch adds the mx35 to the supported cpu-families of the
> > "CPUfreq driver for i.MX CPUs".
> 
> I'm afraid this has to wait another cycle since you are patching a file
> that is scheduled to be replaced with common clock framework support.

Has this "scheduled replacement" somewhere (e.g. calendar) been
marked? So that I can check in the future before editing "scheduled
files".

Thanks,
 -- Christoph
