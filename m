Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1DEX3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:29:38 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36704 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1DEX3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:29:35 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="84173892"
Message-ID: <986071387c1fa1ede387ff36991a3df8.squirrel@www.codeaurora.org>
In-Reply-To: <BANLkTimz0fZnWdGqOF4c+o3Mp4GrmV2T0Q@mail.gmail.com>
References: <1292883633-19553-1-git-send-email-sboyd@codeaurora.org>
    <1292883633-19553-3-git-send-email-sboyd@codeaurora.org>
    <BANLkTimz0fZnWdGqOF4c+o3Mp4GrmV2T0Q@mail.gmail.com>
Date: Tue, 5 Apr 2011 16:29:09 -0700 (PDT)
Subject: Re: [PATCHv4 2/4] ARM: Allow machines to override __delay()
From: "Stephen Boyd" <sboyd@codeaurora.org>
To: "Linus Walleij" <linus.ml.walleij@gmail.com>
Cc: "Stephen Boyd" <sboyd@codeaurora.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Nicolas Pitre" <nicolas.pitre@linaro.org>,
        "John Stultz" <johnstul@us.ibm.com>,
        "Brian Swetland" <swetland@google.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2010/12/20 Stephen Boyd <sboyd@codeaurora.org>:
>
>> Some machines want to implement their own __delay() routine based
>> on fixed rate timers. Expose functionality to set the __delay()
>> routine at runtime. This should allow two machines with different
>> __delay() routines to happily co-exist within the same kernel
>> with minimal overhead.
>
> Can't you guys just put this into Russell's patch tracker now?
> I think the issues raised have been adressed.
>
> Unless this happens I will attempt to rebase it and put it in
> the patch tracker myself soon-ish.
>

Sorry, I'm about to send it now.

