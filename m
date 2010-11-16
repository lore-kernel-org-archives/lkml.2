Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab0KPUL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:11:27 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:49944 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932248Ab0KPUL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:11:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=kQIS5dLyN62z/yGKwPkA69tByeh8ZEM6op2UacHObIkw0VX/QKKEBHI4w9UK7l2w3ufMx4HbjQPwlEuLojzTiFH3ixmGGg5mYCOmkgVoKmcE3nWQTM070OBb5ISXnjCW;
Date: Tue, 16 Nov 2010 12:11:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Keith Packard <keithp@keithp.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
Message-ID: <20101116121107.7728e971@jbarnes-desktop>
In-Reply-To: <20101116204645.2c105e9b@schatten.dmk.lab>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<20101011154826.440b4990@jbarnes-desktop>
	<20101011164014.5a11ee48@jbarnes-desktop>
	<201010122101.17812.rjw@sisk.pl>
	<20101012124938.47170457@jbarnes-desktop>
	<20101116204645.2c105e9b@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 20:46:45 +0100
Florian Mickler <florian@mickler.org> wrote:

> On Tue, 12 Oct 2010 12:49:38 -0700
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > I don't think I buy that VGA is special anyway, at least not for KMS
> > enabled kernels, where vgacon and the BIOS can't assume anything about
> > graphics state anymore.  More generally, I don't think BIOSes have been
> > able to assume anything about the current graphics state since Windows
> > 3.1, when most platforms stopped using BIOS calls and/or VGA regs for
> > mode setting.
> > 
> > Thoughts?
> > 
> 
> does this need to go to 2.6.36.y? (is it already on it's way?)
> 
> commit 97c145f7c87453cec90e91238fba5fe2c1561b32
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Fri Nov 5 15:16:36 2010 -0400
> 
>     PCI: read current power state at enable time

I hadn't planned on pushing this to stable, but if you have a need
for it there, feel free to propose it.

-- 
Jesse Barnes, Intel Open Source Technology Center
