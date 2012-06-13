Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab2FMMxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:53:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40881 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FMMw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:52:58 -0400
Message-ID: <1339591969.8980.30.camel@twins>
Subject: Re: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Andy Whitcroft <apw@canonical.com>
Date: Wed, 13 Jun 2012 14:52:49 +0200
In-Reply-To: <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
>         }
>         smp_wmb();
>  } 

You know what.. we should make checkpatch report an error for memory
barriers that don't have a comment. 

I know this isn't added by this patch, but every time I see something
like it I cry a little.
