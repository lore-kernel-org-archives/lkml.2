Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab2CTX46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 19:56:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55699 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2CTX4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 19:56:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v8 0/8] Consolidate cpuidle functionality
Date: Wed, 21 Mar 2012 01:01:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        Robert Lee <rob.lee@linaro.org>, len.brown@intel.com,
        akpm@linux-foundation.org, robherring2@gmail.com, Baohua.Song@csr.com,
        nicolas.ferre@atmel.com, linux@maxim.org.za, kgene.kim@samsung.com,
        amit.kachhap@linaro.org, magnus.damm@gmail.com, nsekhar@ti.com,
        daniel.lezcano@linaro.org, mturquette@linaro.org,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, deepthi@linux.vnet.ibm.com,
        broonie@opensource.wolfsonmicro.com, nicolas.pitre@linaro.org,
        linux@arm.linux.org.uk, jean.pihet@newoldbits.com, venki@google.com,
        ccross@google.com, g.trinabh@gmail.com, kernel@wantstofly.org,
        lethal@linux-sh.org, jon-hunter@ti.com, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        Len Brown <lenb@kernel.org>
References: <1332274969-15782-1-git-send-email-rob.lee@linaro.org> <873992zy5u.fsf@ti.com> <CAP245DXwhCMOJaspW8SY7jtqsA3d5SK4Ctr+JvS+cw4yHfL-mw@mail.gmail.com>
In-Reply-To: <CAP245DXwhCMOJaspW8SY7jtqsA3d5SK4Ctr+JvS+cw4yHfL-mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203210101.08361.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 21, 2012, Amit Kucheria wrote:
> On Wed, Mar 21, 2012 at 12:48 AM, Kevin Hilman <khilman@ti.com> wrote:
> > Arnd Bergmann <arnd.bergmann@linaro.org> writes:
> >
> >> On Tuesday 20 March 2012, Robert Lee wrote:
> >>> This patch series moves various functionality duplicated in platform
> >>> cpuidle drivers to the core cpuidle driver. Also, the platform irq
> >>> disabling was removed as it appears that all calls into
> >>> cpuidle_call_idle will have already called local_irq_disable().
> >>>
> >>> These changes have been pulled into linux-next.
> >>>
> >>> Len, Andrew, can a request be made for Linus to pull these changes?
> >>
> >> FWIW, Len seems to be rather inactive on the kernel mailing list right
> >> now and generally not very interested in anything outside of x86 and
> >> acpi. If he doesn't reply in the next few days and Andrew also isn't
> >> interested in handling these patches, I'd suggest you just send the pull
> >> request to Linus, with Len on Cc and explain that you tried to send
> >> them through him but gave up in the end.
> >
> > FWIW, I have not had good luck getting response for proposed core
> > CPUidle changes either:
> >
> >        http://lkml.org/lkml/2011/9/19/374
> >
> > Maybe it's time that drivers/cpuidle gets a maintainer.  With lots of
> > discussions of scheduler changes that affect load estimation, I suspect
> > we're all going to have a bit of CPUidle work to do in the
> > not-so-distant future.
> >
> 
> I don't mean to be piling on to Len here, but Daniel Lezcano too has a
> bunch of clean ups that didn't get any maintainer review for over two
> months. He has now refreshed them for 3.3 and is getting ready to send
> them out again. We (Linaro) expect to be spending a lot of time on
> cpuidle in the future and would be glad to help review, test and
> collect patches into a tree for Linus/Andrew to pull while we wait for
> Len to respond or another maintainer to emerge.

Well, I discussed that before with Arjan and he said he would maintain
CPUidle if Len didn't have the time, but it seems he didn't expect that
there would be a lot of work on it in the near future.

So, I suggest that if neither Len nor Arjan reappear shortly, people can
send CPUidle patches to me.

Thanks,
Rafael
