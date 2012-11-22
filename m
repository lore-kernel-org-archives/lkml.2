Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2KVTFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:05:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50086 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab2KVTFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:05:01 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Viresh Kumar <viresh.kumar@linaro.org>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <CAKohpo=fNxADu4z9y6R7XBJEvr7ksOOY0LqZ9MfHnBgmDFgBvg@mail.gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
 <CAKohpo=fNxADu4z9y6R7XBJEvr7ksOOY0LqZ9MfHnBgmDFgBvg@mail.gmail.com>
Message-ID: <20121122040516.21126.17028@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Date: Wed, 21 Nov 2012 20:05:16 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Viresh Kumar (2012-11-21 19:34:18)
> On 22 November 2012 02:13, Mike Turquette <mturquette@ti.com> wrote:
> > HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
> > selecting HAVE_CLK_PREPARE without HAVE_CLK.
> >
> > Looking through the code I see that this used to be the case.  Commit
> > 93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
> > clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
> > commit was authored by you.  Can you elaborate on why that aspect of the
> > patch was needed?
> 
> Haha... Caught red handed :(
> 
> Before this commit, nothing was enclosed within CONFIG_HAVE_CLK and
> this patch only introduced it. I am not really sure, why i kept
> prepare/unprepare
> out of it though :(
> 
> Maybe because some platform at that time is using it directly, without
> CONFIG_HAVE_CLK. Not sure.
> 

No worries.  Looks like everything gets sorted out in the end ;)

Regards,
Mike

> --
> viresh
