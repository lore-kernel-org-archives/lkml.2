Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1C3JIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:08:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:47680 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1C3JIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:08:12 -0400
Date: Wed, 30 Mar 2011 11:08:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: fix build failure introduced by typo in irq namespace
 cleanup.
In-Reply-To: <20110330060229.27397.7628.stgit@ponder>
Message-ID: <alpine.LFD.2.00.1103301107020.22418@localhost6.localdomain6>
References: <20110330060229.27397.7628.stgit@ponder>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Grant Likely wrote:

> Commit 6845664a6a7d443f03883db59d10749d38d98b8e, "arm: Cleanup the irq
> namespace" introduces a typo causing a build failure for the versatile
> platform.

Sorry about that. I have no clue how I fatfingered that in last
minute.

rmk: are you picking it up or should I push it linuswards with the
other fixups ?
 
Thanks,

	tglx
