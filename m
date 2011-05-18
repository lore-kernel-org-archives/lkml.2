Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1ERTqQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:46:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36994 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188Ab1ERTqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:46:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: myungjoo.ham@gmail.com
Subject: Re: [PATCH v2 2/3] PM / DEVFREQ: add example governors
Date: Wed, 18 May 2011 21:46:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Mark Brown <broonie@sirena.org.uk>, Jiejing Zhang <kzjeef@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Colin Cross <ccross@google.com>,
        Nishanth Menon <nm@ti.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <1305100723-29161-1-git-send-email-myungjoo.ham@samsung.com> <201105180039.56806.rjw@sisk.pl> <BANLkTim0DkhcjWw7fM0e-UhyB3=GkQ7nKw@mail.gmail.com>
In-Reply-To: <BANLkTim0DkhcjWw7fM0e-UhyB3=GkQ7nKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105182146.51869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 18, 2011, MyungJoo Ham wrote:
> 2011/5/18 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Wednesday, May 11, 2011, MyungJoo Ham wrote:
> >> Three CPUFREQ-like governors are provided as examples.
> >>
> >> powersave: use the lowest frequency possible. The user (device) should
> >> set the polling_ms as 0 because polling is useless for this governor.
> >>
> >> performance: use the highest freqeuncy possible. The user (device)
> >> should set the polling_ms as 0 because polling is useless for this
> >> governor.
> >>
> >> simple_ondemand: simplified version of CPUFREQ's ONDEMAND governor.
> >>
> >> When a user updates OPP entries (enable/disable/add), OPP framework
> >> automatically notifies DEVFREQ to update operating frequency
> >> accordingly. Thus, DEVFREQ users (device drivers) do not need to update
> >> DEVFREQ manually with OPP entry updates or set polling_ms for powersave
> >> , performance, or any other "static" governors.
> >
> > Well, do you expect anyone to actually use them?  If not, it would make
> > more sense to put them into a doc.
> 
> According to our experiences of DVFS(although this "DEVFREQ" is not
> applied to them, yet) in memory-bus and GPU,
> I expect most DEVFREQ users might use "simple_ondemand" and
> expect "powersave" and "performance" will probably mostly used while
> testing and debugging.
> ("userspace"-like governor would be also useful for that purpose, but
> I'd add it later)

It would be good to have at least one in-tree user for each of them
(not necessarily from the start, but at one point in the future at least).

So if you have any _specific_ users in mind, please let me know.

Thanks,
Rafael
