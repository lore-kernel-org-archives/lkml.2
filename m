Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030886Ab2CFT5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:57:11 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:40063 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030372Ab2CFT5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:57:10 -0500
Date: Tue, 6 Mar 2012 20:57:00 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org
Subject: Re: [PATCH] irq_domain/mips: Allow irq_domain on MIPS
Message-ID: <20120306195700.GK4519@linux-mips.org>
References: <1330100995-19823-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330100995-19823-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 09:29:55AM -0700, Grant Likely wrote:

> This patch makes IRQ_DOMAIN usable on MIPS.  It uses an ugly workaround
> to preserve current behaviour so that MIPS has time to add irq_domain
> registration to the irq controller drivers.  The workaround will be
> removed in Linux v3.6

Looking good, Ack.

Is there any good example for the changes that need to be done to
irq controller drivers?

Thanks,

  Ralf
