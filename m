Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1FFU5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:57:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49135 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752036Ab1FFU5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:57:19 -0400
Date: Mon, 6 Jun 2011 21:57:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Milton Miller <miltonm@bga.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: genirq: Ensure we locate the passed IRQ in irq_alloc_descs()
Message-ID: <20110606205716.GC27341@opensource.wolfsonmicro.com>
References: <1307037313-15733-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <nack-locate@mdm.bga.com>
 <20110603104217.GA4777@opensource.wolfsonmicro.com>
 <locate-from-more@mdm.bga.com>
 <20110603150636.GA9492@opensource.wolfsonmicro.com>
 <alpine.LFD.2.02.1106031823310.3078@ionos>
 <irq-locate-ack@mdm.bga.com>
 <20110604095138.GA708@opensource.wolfsonmicro.com>
 <BANLkTi=MTWcKz0jd_p_n3Yz3DJQp4rs1Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=MTWcKz0jd_p_n3Yz3DJQp4rs1Sg@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 01:42:33PM -0600, Grant Likely wrote:
> On Sat, Jun 4, 2011 at 3:51 AM, Mark Brown

> > I'm not really sure what an IRQ domain is (the patch series you pointed
> > at before does rather appear to assume one knows already)

> (obviously I need to write some documentation).  irq_domains is some
> infrastructure to make managing a range of irq numbers easier, and
> also to handle the mapping of hw irq numbers to linux irq numbers.

Hrm, in that case it sounds rather like a lot of interrupt controllers
ought to be making themselves IRQ domains?
