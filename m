Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1HJC1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 22:27:36 -0400
Received: from frodo.hserus.net ([204.74.68.40]:55114 "EHLO frodo.hserus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1HJC1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 22:27:35 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 22:27:35 EDT
Date: Tue, 9 Aug 2011 23:01:57 -0300
From: Christian Robottom Reis <kiko@linaro.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] cpumask: introduce cpumask for hotpluggable CPUs
Message-ID: <20110810020157.GA29494@anthem.async.com.br>
References: <1312940007-26069-1-git-send-email-mturquette@ti.com>
 <1312940007-26069-2-git-send-email-mturquette@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312940007-26069-2-git-send-email-mturquette@ti.com>
Organization: http://www.linaro.org/
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 06:33:26PM -0700, Mike Turquette wrote:
> - *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
> - *     cpu_present_mask - has bit 'cpu' set iff cpu is populated
> - *     cpu_online_mask  - has bit 'cpu' set iff cpu available to scheduler
> - *     cpu_active_mask  - has bit 'cpu' set iff cpu available to migration
> + *     cpu_possible_mask     - has bit 'cpu' set iff cpu is populatable
> + *     cpu_hotpluggable_mask - has bit 'cpu' set iff cpu is hotpluggable
> + *     cpu_present_mask      - has bit 'cpu' set iff cpu is populated
> + *     cpu_online_mask       - has bit 'cpu' set iff cpu available to scheduler
> + *     cpu_active_mask       - has bit 'cpu' set iff cpu available to migration

Why not fix the 'iff' typo while you're here?
-- 
Christian Robottom Reis, Engineering VP
Brazil (GMT-3) | [+55] 16 9112 6430 | [+1] 612 216 4935
Linaro.org: Open Source Software for ARM SoCs
