Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab1DEWNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 18:13:22 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53564 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1DEWNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 18:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OPImIO5tvj4s0f7YgprGaPlaClZEQLsg6RrbxgV9Xkipkl+GSVzk7cWgHmUkfqwITf
         6qtNnjgl15jzw5QEP5PAovn9O9MleSMGkMoB0io/EQfWApCIjr5N8lWXAucqy2VyKPtC
         TecN9X/3t4d7dfpFOxFbNIyqwSexYu9RctZpM=
MIME-Version: 1.0
In-Reply-To: <1292883633-19553-3-git-send-email-sboyd@codeaurora.org>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
	<1292883633-19553-3-git-send-email-sboyd@codeaurora.org>
Date: Wed, 6 Apr 2011 00:13:16 +0200
Message-ID: <BANLkTimz0fZnWdGqOF4c+o3Mp4GrmV2T0Q@mail.gmail.com>
Subject: Re: [PATCHv4 2/4] ARM: Allow machines to override __delay()
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/20 Stephen Boyd <sboyd@codeaurora.org>:

> Some machines want to implement their own __delay() routine based
> on fixed rate timers. Expose functionality to set the __delay()
> routine at runtime. This should allow two machines with different
> __delay() routines to happily co-exist within the same kernel
> with minimal overhead.

Can't you guys just put this into Russell's patch tracker now?
I think the issues raised have been adressed.

Unless this happens I will attempt to rebase it and put it in
the patch tracker myself soon-ish.

Yours,
Linus Walleij
