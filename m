Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab3ACDcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 22:32:24 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39315 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3ACDcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 22:32:23 -0500
MIME-Version: 1.0
In-Reply-To: <7569403.CvHy03LdiU@vostro.rjw.lan>
References: <98330b2deb910453a356404b8cf774c94326bc42.1355636864.git.viresh.kumar@linaro.org>
	<CAKohpomfEHGrCdbZ-EakRN4=qF8epd5seX5TWRcErQj9BEFpNA@mail.gmail.com>
	<CAKohpomxCSVRXkvde-P6T3Ks=7Z8PX1NSjzFfvKsPYQXTScwRw@mail.gmail.com>
	<7569403.CvHy03LdiU@vostro.rjw.lan>
Date: Thu, 3 Jan 2013 09:02:22 +0530
Message-ID: <CAKohponGtLNBnWWX1miV3zjO4pJPumbWoPwoQ2+adCE5t2w5Dw@mail.gmail.com>
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

On 3 January 2013 06:43, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> BTW, i consider them as fixes and so would make sense to get them in next rc.
>> What do you think?
>
> Yes, if somebody tells me "yes, this fixes a problem for me".  Otherwise,
> I don't quite see the reason.

I don't know how much people test HOTPLUG, but there are clear bugs related
to hotplug of cpus on a multiple cpu system :)
