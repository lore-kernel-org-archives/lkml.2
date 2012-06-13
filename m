Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2FMNHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:07:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55098 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2FMNHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:07:45 -0400
Message-ID: <1339592856.8980.33.camel@twins>
Subject: Re: [RFC 3/4] ARM: topology: Update cpu_power according to DT
 information
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Date: Wed, 13 Jun 2012 15:07:36 +0200
In-Reply-To: <1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-4-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> +struct cpu_capacity cpu_capacity[NR_CPUS];

I know ARM isn't likely to suffer from the 4k cpu issue, but is there a
reason to use a NR_CPUS array over a per-cpu variable?
