Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0LQPgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:36:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab0LQPgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qTNYgguFRl1owKF338M8MIoKdPVoGhPVdcH3Zv3LWUH4hm7kk5dyRel3Om3nTvt5ZY
         aGSSj2h7453wrI4wd5DrXUAibPKtkNhos1XmHazALIl5SRgPrAs1IIyoMWHH1HZLtOBe
         8hW4M/3upApE5r8reHrPlSKuS8hPA0NmKR04g=
MIME-Version: 1.0
In-Reply-To: <1292599007.2266.290.camel@twins>
References: <7997200675c1a53b1954fdc3f46dd208db5dea77.1292578808.git.harald.gustafsson@ericsson.com>
	<1292596194.2266.283.camel@twins>
	<1292596369.2266.286.camel@twins>
	<AANLkTinGkf3a4_sw32b4UqAmpUU+i6fDmDUT8tXdw14D@mail.gmail.com>
	<1292599007.2266.290.camel@twins>
Date: Fri, 17 Dec 2010 16:36:47 +0100
Message-ID: <AANLkTi=Etj3eu25cBuESoXdo3pMnJymFcicW9YN3LMn7@mail.gmail.com>
Subject: Re: [PATCH 1/3] Added runqueue clock normalized with cpufreq
From: Harald Gustafsson <hgu1972@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Dario Faggioli <faggioli@gandalf.sssup.it>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Michael Trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/17 Peter Zijlstra <peterz@infradead.org>:
> I was more hinting at the fact that CPUfreq is at best a controversial
> approach to power savings. I much prefer the whole race-to-idle
> approach, its much simpler.

That depends to a large degree on architecture, chip technology node
and deployed user space
applications. I don't agree that race-to-idle is a good idea for
some/many combinations at least
for embedded systems. But of course race-to-idle is simpler, but not
necessarily giving the
lowest energy.

/Harald
