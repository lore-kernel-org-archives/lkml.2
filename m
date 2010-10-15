Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab0JOW4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 18:56:11 -0400
Received: from smtp-out.google.com ([74.125.121.35]:2127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0JOW4J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 18:56:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wGCMyfvr48EfWOXVsuoCU3tEYAsNZXJGp0dVo0l6pGYmSYf05V9celunsRA0fMOogt
         J8VKbJk8JbnP5tmYjlRw==
MIME-Version: 1.0
In-Reply-To: <20101015223501.GA18609@kroah.com>
References: <1287089791-25673-1-git-send-email-achew@nvidia.com>
	<AANLkTim1LQ5xE9fxT9JgKb4a7AKsnRF+3daHcSGBKK4O@mail.gmail.com>
	<20101015223501.GA18609@kroah.com>
Date: Fri, 15 Oct 2010 15:55:57 -0700
Message-ID: <AANLkTi=-DVhrzvwq_u5LBdshF8S71ike_LTwiwoaXb8F@mail.gmail.com>
Subject: Re: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
From: Erik Gilling <konkers@google.com>
To: Greg KH <greg@kroah.com>
Cc: achew@nvidia.com, jmayo@nvidia.com, a.zummo@towertech.it, olof@lixom.net,
        mcuos.com@gmail.com, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 3:35 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Oct 15, 2010 at 03:12:47PM -0700, Erik Gilling wrote:
>> > --- /dev/null
>> > +++ b/drivers/rtc/rtc-tegra.c
>> > @@ -0,0 +1,509 @@
>> > +/*
>> > + * An RTC driver for the NVIDIA Tegra 200 series internal RTC.
>> > + *
>> > + * Copyright (c) 2010, NVIDIA Corporation.
>> > + * Copyright (c) 2010 Jon Mayo <jmayo@nvidia.com>
>>
>> This is kinda odd.  Usually when doing work on behalf of the company
>> you work for, the code is (c) the company.  Consider changing Jon's
>> line to "Author: Jon Mayo <jmayo@nvidia.com>"
>
> Woah, are you sure?  Some companies, and countries, allow/require dual
> copyright.  The only one who can change this for sure is Jon, not anyone
> else.

I stand corrected.  However, I have yet to see a Tegra patch from
nvidia that lists any author name, copyright or no.  Jon, can you
clarify?

-Erik
