Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1FCPsV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 11:48:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55174 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab1FCPsU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 11:48:20 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=-YdaU07TrJsbJuZ9SrYi9uV0ACQ@mail.gmail.com>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
 <20110603075201.GE10532@n2100.arm.linux.org.uk> <20110603143406.GA19344@S2100-06.ap.freescale.net>
 <BANLkTi=5kNAt51DP3-rykkT3ZONczD5Crg@mail.gmail.com> <20110603152643.GB19344@S2100-06.ap.freescale.net>
 <BANLkTi=-YdaU07TrJsbJuZ9SrYi9uV0ACQ@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 3 Jun 2011 09:48:00 -0600
X-Google-Sender-Auth: M0zZsvvQQO0okiwQ4YyH45NDiXw
Message-ID: <BANLkTi=odpKzvkFfhdbinH3j8-Omz9HM2g@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Move plat-mxc gpio driver into drivers/gpio
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, arnd@arndb.de,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, olof@lixom.net,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 9:47 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Fri, Jun 3, 2011 at 9:26 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>> Hi Grant,
>>
>> On Fri, Jun 03, 2011 at 08:55:58AM -0600, Grant Likely wrote:
>>> On Fri, Jun 3, 2011 at 8:34 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
>>> > Hi Russell,
>>> >
>>> > On Fri, Jun 03, 2011 at 08:52:01AM +0100, Russell King - ARM Linux wrote:
>>> >> On Thu, Jun 02, 2011 at 11:33:48AM +0800, Shawn Guo wrote:
>>> >> >  arch/arm/plat-mxc/gpio.c                        |  361 -------------------
>>> >> >  drivers/gpio/gpio-mxc.c                         |  433 +++++++++++++++++++++++
>>> >>
>>> > My bad here.  I should have used 'git diff --stat -M' to show the
>>> > the following.
>>> >
>>> > .../arm/plat-mxc/gpio.c => drivers/gpio/gpio-mxc.c |  216 +++++++++++++-------
>>> >
>>> >> I'm wondering why just moving this driver into drivers/gpio has
>>> >> resulted in it growing by 72 lines - and it's not clear from the
>>> >> diffs why that is because of the way they're broken up.
>>> >>
>>> > Yes, I agree.  But when I did something like that to ease the review,
>>> > people think it's not necessary :)
>>> >
>>> > http://permalink.gmane.org/gmane.linux.kernel/1143257
>>>
>>> The issue was bisectability: it looked like the build would break
>>> after applying the first patch.  The first patch should move the
>>
>> Yes, the build would break only if you change Kconfig/Makefile to
>> actually build it.  The patch does not enable the build of the driver
>> in the patch.
>>
>>> driver without breaking the build, and then you can follow up with
>>> driver fixes.  I don't want to see functional changes mixed in with
>>> the file move change.
>>>
>> Understood.  Do you want me to resend the gpio-mxs and gpio-mxc patch
>> sets for that?  Or can I follow the practice you and Russell
>> suggested in the future posts?  I have learnt the lesson.
>
> Please repost.

An you can add in any acked-by you've received on these patches.

g.
