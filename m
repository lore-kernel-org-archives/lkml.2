Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319Ab1ETFYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 01:24:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1ETFYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 01:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=CvUJmrWb9YtFm9s7P+B/IWMYpa8YpcqePo5qGXDmi5qveAJ1vUl9ff5UbyfNJaoL7K
         mRGIc1LvWB1rhrzjjykw==
MIME-Version: 1.0
In-Reply-To: <20110426014741.GB28721@quad.lixom.net>
References: <1302822031-6752-1-git-send-email-sjg@chromium.org>
	<4DA7A914.5020804@codeaurora.org>
	<BANLkTikcY-xzjd0W77UfWWoO8ibjKNXQGg@mail.gmail.com>
	<BANLkTin_TpzdQS96SPKUNye6vb2b55Qc4A@mail.gmail.com>
	<143ea9b1bb96e613d534caa7cb3a1e2d.squirrel@www.codeaurora.org>
	<20110426014741.GB28721@quad.lixom.net>
Date: Thu, 19 May 2011 22:24:31 -0700
X-Google-Sender-Auth: cUXVtQY9FqMtLxfSJmqRlC00umw
Message-ID: <BANLkTikHT2E=76jMLbzmQm_CiUw8rA3cCA@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: Use generic BUG() handler
From: Simon Glass <sjg@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        anish singh <anish198519851985@gmail.com>,
        lak <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Joe Perches <joe@perches.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexander Shishkin <virtuoso@slind.org>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>,
        Rabin Vincent <rabin@rab.in>, lk <linux-kernel@vger.kernel.org>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Dave Martin <dave.martin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 6:47 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Apr 20, 2011 at 11:01:59AM -0700, Stephen Boyd wrote:
>
>> It's here:
>> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6885/1
>>
>> I imagine it will be added when/if Russell picks it up. Sadly it
>> increases the LOC in ARM so Simon might need to really
>> sell it to get it merged.
>
> It's core code though, and the concern today is not with ARM core code
> as much as with the various platforms that are growing seemingly without
> upper bounds.

Hi,

Can anyone advise please what happens next with this patch? So far I
have posted it to the list, it has been reviewed on the list and I
have put it into the patch system. What is the next step please to get
this into the kernel?

Regards,
Simon

>
>
> -Olof
>
