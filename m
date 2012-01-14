Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2ANU32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 15:29:28 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38141 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756625Ab2ANU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 15:29:27 -0500
Message-ID: <1326572965.6300.103.camel@joe2Laptop>
Subject: Re: [PATCH] pch_gbe: Use a randomly generated MAC instead of
 failing probe
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: dvhart@linux.intel.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, alan@linux.intel.com, tomoya.rohm@gmail.com,
        jeffrey.t.kirsher@intel.com, paul.gortmaker@windriver.com,
        jdmason@kudzu.us, netdev@vger.kernel.org
Date: Sat, 14 Jan 2012 12:29:25 -0800
In-Reply-To: <20120114.115604.2101782124431552110.davem@davemloft.net>
References: <132d2a41a089905de3147b4656e350608aa7fd6f.1326523495.git.dvhart@linux.intel.com>
	 <20120114.001430.787918662083526597.davem@davemloft.net>
	 <4F11A533.4040406@linux.intel.com>
	 <20120114.115604.2101782124431552110.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-01-14 at 11:56 -0800, David Miller wrote:
> From: Darren Hart <dvhart@linux.intel.com>
> Date: Sat, 14 Jan 2012 07:54:27 -0800
> > In any case, with existing hardware out there that is unusable with the
> > current pch_gbe driver, can we consider this workaround for inclusion?
> I fear that people are just going to add this random MAC stuff way too
> easily, it's a spreading disease.
> Ship functional hardware instead.

Good advice, but that's _hard_.

Working systems are nearly always some combination
of hardware/firmware/software defect workarounds.

Anyway, perhaps setting random_ether_addr like this
should be in some generic routine with a standardized
"avoid buying bad hardware" output logging message.


