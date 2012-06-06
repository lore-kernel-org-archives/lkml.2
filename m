Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2FFViT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:38:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:52188 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab2FFViS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:38:18 -0400
Date: Wed, 6 Jun 2012 23:38:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Chen Gong <gong.chen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/6] x86: mce: Create devices in CPU_UP_PREPARE
In-Reply-To: <20120606212334.513459224@linutronix.de>
Message-ID: <alpine.LFD.2.02.1206062337310.3086@ionos>
References: <20120606211746.693649684@linutronix.de> <20120606212334.513459224@linutronix.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Thomas Gleixner wrote:

> This makes the treshold_cpu_callback for AMD actually work and makes
> the code symetric vs. teardown.

Ignore that. I sent out the wrong version of this lot. Sorry for the noise
