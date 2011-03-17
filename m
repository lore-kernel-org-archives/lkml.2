Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1CQM6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 08:58:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54238 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753738Ab1CQM6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 08:58:41 -0400
Date: Thu, 17 Mar 2011 13:58:39 +0100
From: Cyril Hrubis <metan@ucw.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
        zaurus-devel@www.linuxtogo.org, Marek Vasut <marek.vasut@gmail.com>
Subject: Re: reboot/kexec in 2.6.38
Message-ID: <20110317125839.GB21290@atrey.karlin.mff.cuni.cz>
References: <20110317064523.GA1995@ucw.cz> <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik1CdT4k8SJop7b-MjR27RzF7a=i7WuodNKJi+J@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> > I got report that  reboot/kexec does not work in recent kernels.
> >
> > I tried both kexec and reboot in 2.6.38, and it worked ok. Maybe
> > config issue?
> 
> I think it's config issue. Never heard of this.
>

I've seen that on my zaurus a month or two ago. When kexeced to pxa-linux-2.6
then tried to kexec again. The last thing I've seen was Bye on the framebuffer
console and the machine freezed.

-- 
metan 
