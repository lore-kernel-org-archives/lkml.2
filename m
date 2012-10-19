Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067Ab2JSGCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 02:02:54 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46467 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757021Ab2JSGCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 02:02:53 -0400
MIME-Version: 1.0
In-Reply-To: <20121019055943.GA4185@localhost.localdomain>
References: <1350559712-8514-1-git-send-email-shiraz.hashim@st.com>
	<CAOh2x=mdtkW=a-xv1BeHxoGsgbF5s+4B8QmZBdvqnWHr30Ap2A@mail.gmail.com>
	<20121019055943.GA4185@localhost.localdomain>
Date: Fri, 19 Oct 2012 11:32:51 +0530
Message-ID: <CAKohpomTYiTG6U7Daj4xJ9Qu=ZPuMz4Ba==O2_oP8DY2XV9aJg@mail.gmail.com>
Subject: Re: [PATCH] pwm: add spear pwm driver support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Shiraz Hashim <shiraz.hashim@st.com>
Cc: thierry.reding@avionic-design.de, spear--sw-devel@lists.codex.cro.st.com,
        linux-kernel@vger.kernel.org, spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 October 2012 11:29, Shiraz Hashim <shiraz.hashim@st.com> wrote:
>> > +               clk_disable_unprepare(pc->clk);
>>
>> call only disable from here. Leave it prepared for ever.
>>
>
> and unprepare only in _remove. Okay.

yes.

> I need to shut down all active pwms, how else would you suggest that ?

I misread the code. Leave this comment.
