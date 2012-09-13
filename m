Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2IMHdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:33:12 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45273 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab2IMHdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:33:09 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:d9d2:3ecd:9fd1:b4c3]
In-Reply-To: <20120913073103.GA10231@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
	<CAOesGMhyQd=p23uy1Lj9iq6PKgS+kJ+xh4Z10e4XbSk50E=U7Q@mail.gmail.com>
	<20120913073103.GA10231@codeaurora.org>
Date: Thu, 13 Sep 2012 00:33:07 -0700
Message-ID: <CAOesGMjPX=9h0N8f50wf_efxmR9qgH8c3fyKDbePMC7sPprjLg@mail.gmail.com>
Subject: Re: [GIT PULL] msm-core changes for v3.7
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:31 AM, David Brown <davidb@codeaurora.org> wrote:
> On Wed, Sep 12, 2012 at 11:36:28PM -0700, Olof Johansson wrote:
>
>> I think it could be a good idea to split off the cleanups and fixes to
>> a separate branch. For the other patches there seems to be enough for
>> at least a 'dt' branch and either a multi-platform topic branch or a
>> 'boards' topic branch -- probably the former. So see my annotation
>> below for suggested sorting (I didn't check for
>> conflicts/dependencies).
>
> I'll give a go at splitting things up tomorrow, then.  I'd held off on
> making separate branches because there are a bunch of changes to
> similar stuff.  Even if I get them separated, they are unlikely to
> build without all being applied.
>
> But, I'll see what I can do.

Ok. If it's too hairy this time around, let us know and we can figure
something out. Over time hopefully it'll get easier to sort patches in
buckets.


-Olof
