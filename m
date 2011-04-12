Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276Ab1DLSNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:13:09 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:38351 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755442Ab1DLSNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:13:06 -0400
Date: Tue, 12 Apr 2011 20:13:05 +0200
From: Cyril Hrubis <metan@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
        rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>,
        Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: reboot/kexec in 2.6.38
Message-ID: <20110412181305.GB2665@atrey.karlin.mff.cuni.cz>
References: <20110317064523.GA1995@ucw.cz> <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com> <20110322133034.GA15475@atrey.karlin.mff.cuni.cz> <m1bp0zylgg.fsf@fess.ebiederm.org> <20110412144330.GB20815@atrey.karlin.mff.cuni.cz> <BANLkTikZXjfD82DxoahkvUo+26cjvOKZmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikZXjfD82DxoahkvUo+26cjvOKZmw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> >> Enable early_printk to a serial port if you can.
> >>
> >> There is definitely an issue in 2.6.38 where kdump doesn't work, that
> >> right now looks like a memblock issue.
> >
> > Finaly got time to solder serial adapter...
> >
> > And now, after I configured kernel to print to both ttyS0 serial console and
> > tty0 the kexec started to work.
> 
> Cool. Please help check why it didn't work, and see if we have something
> broken.

Hmm, It seems to work now (I've changed the config slightly meanwhile and now
I've been unable to trigger the bug).

Note to myself: save configs that trigger strange behavior.

-- 
metan
