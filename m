Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3ABGaC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 01:30:02 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:44413 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3ABG36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 01:29:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomfEHGrCdbZ-EakRN4=qF8epd5seX5TWRcErQj9BEFpNA@mail.gmail.com>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
	<4137114.myBUIQvsg3@vostro.rjw.lan>
	<CAKohpomfEHGrCdbZ-EakRN4=qF8epd5seX5TWRcErQj9BEFpNA@mail.gmail.com>
Date: Wed, 2 Jan 2013 11:59:57 +0530
Message-ID: <CAKohpomxCSVRXkvde-P6T3Ks=7Z8PX1NSjzFfvKsPYQXTScwRw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq: Manage only online cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linaro-dev@lists.linaro.org, nicolas.pitre@linaro.org,
        amit.kucheria@linaro.org, mathieu.poirier@linaro.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        pdsw-power-team@arm.com, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 December 2012 19:07, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 16 December 2012 18:34, Rafael J. Wysocki <rjw@sisk.pl> wrote:

>> Well, this series makes sense to me, but I'd like to hear what the other people
>> think.
>
> That sounds great :)
>
> Some more information for others about how i reached to these issues
> is present here:
>
> https://lkml.org/lkml/2012/12/10/44

Hmm.. I don't know, if we are going to get any feedback from others :(

BTW, i consider them as fixes and so would make sense to get them in next rc.
What do you think?

--
viresh
