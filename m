Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2JSKBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 06:01:36 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:41908 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758407Ab2JSKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 06:01:34 -0400
Date: Fri, 19 Oct 2012 15:31:23 +0530
From: Shiraz Hashim <shiraz.hashim@st.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: <thierry.reding@avionic-design.de>,
        <spear--sw-devel@lists.codex.cro.st.com>,
        <linux-kernel@vger.kernel.org>, <spear-devel@list.st.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
Message-ID: <20121019100123.GD4185@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
 <CAOh2x=mdtkW=a-xv1BeHxoGsgbF5s+4B8QmZBdvqnWHr30Ap2A@mail.gmail.com>
 <20121019055943.GA4185@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121019055943.GA4185@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 11:29:43AM +0530, Shiraz HASHIM wrote:
> On Thu, Oct 18, 2012 at 11:11:06PM +0530, viresh kumar wrote:
> > On Thu, Oct 18, 2012 at 4:58 PM, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> > > +       pc->mmio_base = devm_request_and_ioremap(&pdev->dev, r);
> > > +       if (!pc->mmio_base)
> > > +               return -EADDRNOTAVAIL;
> > 
> > Just check, i believe there is a routine which will do above two in a single
> > call..
> > 
> 
> I would cross check.
> 

Couldn't find a suitable call.

--
regards
Shiraz
