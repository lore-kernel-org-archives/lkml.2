Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1ABAkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 19:40:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:54926 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1ABAkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 19:40:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,261,1291622400"; 
   d="scan'208";a="873632396"
Message-ID: <4D1FC962.80605@linux.intel.com>
Date: Sat, 01 Jan 2011 16:40:02 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/15] x86: Add device tree support
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-3-git-send-email-bigeasy@linutronix.de> <20101230084311.GD11721@angua.secretlab.ca> <AANLkTi=EFewaizO=1FLALE0eQPUmaFPfTmgoeF+JRpkt@mail.gmail.com>
In-Reply-To: <AANLkTi=EFewaizO=1FLALE0eQPUmaFPfTmgoeF+JRpkt@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2010 01:01 PM, Grant Likely wrote:
> Hi Peter,
> 
> Since this series is based on the tip tree, these should be merged via
> the same route.  Aside from the comments below, I'm okay with patches
> 1 & 2 going in for 2.6.38 (assuming NO_IRQ is fixed).  I've picked up
> patch 12 since it is a generic fix.  I haven't made a decision on the
> remaining 14 yet.
> 

OK... I'll see if I can get it into -tip early next week.  I don't know
how much time there is left before the .38 merge window opens, but I
don't think there is too much.

(tglx: if you want to put it instead of me, go for it and feel free to
add my Ack.)

	-hpa
