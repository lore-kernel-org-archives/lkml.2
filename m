Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935504Ab1IOXrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:47:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:47596 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935304Ab1IOXrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:47:20 -0400
Date: Fri, 16 Sep 2011 01:47:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
In-Reply-To: <1316128013-21980-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109160143450.2723@ionos>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Sep 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

How informative! Can you explain what's the actual fix is ???

Just get it:

  Changelogs are important and not just a random collection of
  characters required by some random tool

Thanks,

	tglx


