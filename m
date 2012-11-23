Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2KWTtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 14:49:32 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:35287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2KWTta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 14:49:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] cpufreq: ondemand: handle SW coordinated CPUs
Date: Fri, 23 Nov 2012 20:54:01 +0100
Message-ID: <1694807.007dnPzdVx@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121123124221.GA7378@balto.lan>
References: <1353663117-10074-1-git-send-email-fabio.baltieri@linaro.org> <20121123124221.GA7378@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 23, 2012 01:42:21 PM Fabio Baltieri wrote:
> Hi Rafael,
> 
> On Fri, Nov 23, 2012 at 10:31:56AM +0100, Fabio Baltieri wrote:
> >  drivers/cpufreq/cpufreq_ondemand.c | 152 ++++++++++++++++++++++++++++++++-----
> >  1 file changed, 132 insertions(+), 20 deletions(-)
> 
> I just noticed that the whole ondemand driver was refactored in your
> linux-pm.git/linux-next branch so my patch does not apply.  I'm
> preparing a rebased version of the set, so feel free to skip this one.

Thanks for the heads up, I'll wait for the new version.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
