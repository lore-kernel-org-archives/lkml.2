Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1HZKHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:07:05 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60917 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754568Ab1HZKHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:07:01 -0400
Subject: Re: [PATCH v2 03/43] arm: Use set_current_blocked() and
 block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
In-Reply-To: <20110825171556.GH27143@e102144-lin.cambridge.arm.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-4-git-send-email-matt@console-pimps.org>
	 <20110825171556.GH27143@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Aug 2011 11:06:34 +0100
Message-ID: <1314353194.17145.9.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-25 at 18:15 +0100, Will Deacon wrote:
> Ok. Looks like the only change from v1 is calling block_sigmask. which does
> what was previously done inline (in v1).
> 
> So you can keep my ack if you like!

Thanks!

Oleg, could you add Will's Acked-by?

-- 
Matt Fleming, Intel Open Source Technology Center

