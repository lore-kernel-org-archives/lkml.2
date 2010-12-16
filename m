Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab0LPVfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 16:35:07 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:61402 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793Ab0LPVfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 16:35:01 -0500
MIME-Version: 1.0
X-Originating-IP: [46.116.87.10]
In-Reply-To: <20101216210837.GA22895@kroah.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com> <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
 <20101216210837.GA22895@kroah.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 16 Dec 2010 23:34:40 +0200
Message-ID: <AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        akpm@linux-foundation.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 11:08 PM, Greg KH <greg@kroah.com> wrote:
>> > I've seen a lot of discussion about this, are all of the review comments
>> > now addressed?
>>
>> Yes, all comments were addressed in this v3 iteration, and this thread
>> has been idle for about 10 days.
>
> That's because we are all busy with other things :(

Oh sure, my intention was only positive (to demonstrate that there are
no outstanding comments), sorry if it sounded differently than
intended.

> Sorry, I really don't have the time at the moment to review this code,
> nor does it seem to affect areas that I maintain, so I don't understand
> what you are looking for from me.

Sorry for the noise - I contacted you because you maintain the driver
core, in the hope you could suggest where this can go through.

Tony, Andrew, can you please have a look ?

Any comment or suggestion is appreciated.

Thanks,
Ohad.
