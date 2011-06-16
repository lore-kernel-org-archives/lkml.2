Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1FPNtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 09:49:03 -0400
Received: from frodo.hserus.net ([204.74.68.40]:40911 "EHLO frodo.hserus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab1FPNtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 09:49:01 -0400
X-Greylist: delayed 1450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 09:49:01 EDT
Date: Thu, 16 Jun 2011 10:24:41 -0300
From: Christian Robottom Reis <kiko@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: [RFC] Add Arm cpu topology definition
Message-ID: <20110616132441.GJ14846@anthem.async.com.br>
References: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinRGRUxKB=C_2Y2F93czWScEUo+Jw@mail.gmail.com>
Organization: http://www.linaro.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 10:49:13AM +0200, Vincent Guittot wrote:
> @@ -219,6 +219,24 @@ source "kernel/Kconfig.freezer"
> 
>  menu "System Type"
> 
> +config SCHED_MC
> +	bool "Multi-core scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Multi-core scheduler support improves the CPU scheduler's decision
> +	  making when dealing with multi-core CPU chips at a cost of slightly
> +	  increased overhead in some places. If unsure say N here.
> +
> +config SCHED_SMT
> +	bool "SMT scheduler support"
> +	depends on SMP && ARM_CPU_TOPOLOGY
> +	default n
> +	help
> +	  Improves the CPU scheduler's decision making when dealing with
> +	  MultiThreading at a cost of slightly increased overhead in some
> +	  places. If unsure say N here.
> +

Quick question: the patch doesn't actually seem to use the SCHED_MC and
SCHED_SMT config bits; is that actually correct?
-- 
Christian Robottom Reis   | [+55] 16 9112 6430 | http://launchpad.net/~kiko
Linaro Engineering VP     | [ +1] 612 216 4935 | http://async.com.br/~kiko
