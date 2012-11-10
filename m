Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2KJIM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 03:12:57 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56701 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab2KJIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 03:12:53 -0500
Date: Sat, 10 Nov 2012 00:12:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 2/3] input: stmpe-ts: Use devm_*() routines
Message-ID: <20121110081249.GA14761@core.coreip.homeip.net>
References: <3d6f34ca5960203a5efb761f4d56b4e10ee24827.1352474824.git.viresh.kumar@linaro.org>
 <52b9fe53a8bd8dff7105209c5b1fab9da7a1510d.1352474824.git.viresh.kumar@linaro.org>
 <CAKohpomC1KTLk=UVim4gdYhJ5kngTZHOUvUgckD75AVH1w+FHw@mail.gmail.com>
 <20121110080009.GA12015@core.coreip.homeip.net>
 <CAKohponua2d95scdwmNsnVpG18nFYA1cuQa703kPfR7D8gF5fg@mail.gmail.com>
 <CAKohponupMgdMh8bvYaF+i9gRtwSJ9t4j+Gdy7mAieR8imc5Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponupMgdMh8bvYaF+i9gRtwSJ9t4j+Gdy7mAieR8imc5Kw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2012 at 01:34:33PM +0530, Viresh Kumar wrote:
> On 10 November 2012 13:33, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 10 November 2012 13:30, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >> Sometimes your mailer does wrap long lines, please make sure to turn it
> >> off for patches.
> >
> > I am using gmail for replying on mails and this fixup was done using that. Don't
> > know why it happened.
> >
> > I am doing the same step again to verify what's playing with patches.
> > On this copy
> > i can see that this issue isn't there till now.
> >
> > diff --git a/drivers/input/touchscreen/stmpe-ts.c
> 
> > @@ -344,8 +344,6 @@ static int __devexit stmpe_ts_remove(struct
> > platform_device *pdev)
> 
> wrapped again.. Don't know how to disable it. :(

I just use mutt...

-- 
Dmitry
