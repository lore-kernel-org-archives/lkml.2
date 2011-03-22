Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1CVNaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 09:30:39 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38084 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754189Ab1CVNah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 09:30:37 -0400
Date: Tue, 22 Mar 2011 14:30:34 +0100
From: Cyril Hrubis <metan@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: reboot/kexec in 2.6.38
Message-ID: <20110322133034.GA15475@atrey.karlin.mff.cuni.cz>
References: <20110317064523.GA1995@ucw.cz> <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> I think it's config issue. Never heard of this.

I've just compiled and booted 2.6.38. The kernel boots without problems when
flashed in. But I've had no success with kexec, the last lines I see are:

Starting new kernel
Bye!
_

Any ides where to dig?

-- 
metan
