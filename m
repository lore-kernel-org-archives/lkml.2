Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3ACBHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:07:35 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:57617 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab3ACBHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:07:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
Date: Thu, 03 Jan 2013 02:13:08 +0100
Message-ID: <7569403.CvHy03LdiU@vostro.rjw.lan>
User-Agent: KMail/4.9.4 (Linux/3.8.0-rc1+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <CAKohpomxCSVRXkvde-P6T3Ks=7Z8PX1NSjzFfvKsPYQXTScwRw@mail.gmail.com>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org> <CAKohpomfEHGrCdbZ-EakRN4=qF8epd5seX5TWRcErQj9BEFpNA@mail.gmail.com> <CAKohpomxCSVRXkvde-P6T3Ks=7Z8PX1NSjzFfvKsPYQXTScwRw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 02, 2013 11:59:57 AM Viresh Kumar wrote:
> On 16 December 2012 19:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 16 December 2012 18:34, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> >> Well, this series makes sense to me, but I'd like to hear what the other people
> >> think.
> >
> > That sounds great :)
> >
> > Some more information for others about how i reached to these issues
> > is present here:
> >
> > https://lkml.org/lkml/2012/12/10/44
> 
> Hmm.. I don't know, if we are going to get any feedback from others :(

Surely somebody cares except for us two?

> BTW, i consider them as fixes and so would make sense to get them in next rc.
> What do you think?

Yes, if somebody tells me "yes, this fixes a problem for me".  Otherwise,
I don't quite see the reason.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
