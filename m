Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1DLOne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:43:34 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:49699 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932455Ab1DLOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:43:32 -0400
Date: Tue, 12 Apr 2011 16:43:30 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: reboot/kexec in 2.6.38
Message-ID: <20110412144330.GB20815@atrey.karlin.mff.cuni.cz>
References: <20110317064523.GA1995@ucw.cz> <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com> <20110322133034.GA15475@atrey.karlin.mff.cuni.cz> <m1bp0zylgg.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bp0zylgg.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >> I think it's config issue. Never heard of this.
> >
> > I've just compiled and booted 2.6.38. The kernel boots without problems when
> > flashed in. But I've had no success with kexec, the last lines I see are:
> >
> > Starting new kernel
> 
> Enable early_printk to a serial port if you can.
> 
> There is definitely an issue in 2.6.38 where kdump doesn't work, that
> right now looks like a memblock issue.

Finaly got time to solder serial adapter...

And now, after I configured kernel to print to both ttyS0 serial console and
tty0 the kexec started to work.

-- 
metan
