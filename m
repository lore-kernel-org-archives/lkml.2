Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2GJHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 03:19:11 -0400
Received: from void.printf.net ([89.145.121.20]:50042 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2GJHTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 03:19:09 -0400
From: Chris Ball <cjb@laptop.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Boot regression on Mackerel with current mainline
References: <201207031218.24797.rjw@sisk.pl>
	<Pine.LNX.4.64.1207031336320.29890@axis700.grange>
	<201207031910.24864.rjw@sisk.pl>
	<Pine.LNX.4.64.1207041125330.21042@axis700.grange>
	<87ipdws1mc.fsf@octavius.laptop.org>
	<Pine.LNX.4.64.1207100845130.29825@axis700.grange>
Date: Tue, 10 Jul 2012 03:19:00 -0400
In-Reply-To: <Pine.LNX.4.64.1207100845130.29825@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue, 10 Jul 2012 08:49:37 +0200 (CEST)")
Message-ID: <87r4skqe1n.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Tue, Jul 10 2012, Guennadi Liakhovetski wrote:
>> > The latter one looks big because of a rename, but with "-M" it's pretty 
>> > trivial. Chris, do you agree?
>> 
>> Is the minimal fix to just add "| IRQF_ONESHOT" to the request_threaded_irq
>> argument?  If so, I'd rather push just that for 3.5, and I can take care of
>> having that change appear simultaneously in linux-next so that there aren't
>> any conflicts.  Is that okay with you?
>
> For that you'd have to rebase -next, right? you'd like to do that?

Yeah, I'm willing to rebase mmc-next for this -- I'd rather send the
simplest possible fix this late in 3.5-rc, and the rebase is simple.
Also, this fix is logically distinct from your rename patch.

I don't think I need you to send anything more, I'll add the initial
patch adding "| IRQF_ONESHOT", rebase your "extend and rename" patch on
top of that, push both to mmc-next, and then send the initial patch to
Linus in a few days.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
