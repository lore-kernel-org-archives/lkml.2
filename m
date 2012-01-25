Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2AYO53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:57:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:59337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab2AYO52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:57:28 -0500
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20120116162241.29759.13220.stgit@localhost>
References: <20120116161740.29759.4679.stgit@localhost>
	 <20120116162241.29759.13220.stgit@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Jan 2012 15:57:26 +0100
Message-ID: <1327503446.2614.77.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 21:52 +0530, Vaidyanathan Srinivasan wrote:
> +enum powersavings_level {
> +       POWERSAVINGS_DISABLED = 0,      /* Max performance */
> +       POWERSAVINGS_DEFAULT,           /* Kernel default policy, automatic powersave */
> +                                       /* vs performance tradeoff */
> +       POWERSAVINGS_MAX                /* Favour power savings over peformance */
>  }; 

I don't like that, I can get, OFF, AUTO, ON, but to overload that with
different policies for AUTO and ON just reeks.

