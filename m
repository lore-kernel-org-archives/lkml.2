Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1BAINB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:13:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58786 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1BAIM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:12:59 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.165.51]
In-Reply-To: <20110131234028.8744b5fd.akpm@linux-foundation.org>
References: <1296470024-26854-1-git-send-email-ohad@wizery.com>
 <1296470024-26854-2-git-send-email-ohad@wizery.com> <20110131153831.dca62146.akpm@linux-foundation.org>
 <AANLkTik-fgCF_W0-DBE6UVTpjqF6Jf=u7bQYkcweEegQ@mail.gmail.com>
 <20110131223859.27169db0.akpm@linux-foundation.org> <AANLkTinJLAT0B61Eu1Chn9k9rmbHXa1ZNcedo_m8TZp3@mail.gmail.com>
 <20110131234028.8744b5fd.akpm@linux-foundation.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 1 Feb 2011 10:12:38 +0200
Message-ID: <AANLkTi=zOO_vDQ4+LWQs38xjo+VaRG0jfgo6ifvh=L-M@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] drivers: hwspinlock: add framework
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 9:40 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 1 Feb 2011 09:36:22 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
>> On Tue, Feb 1, 2011 at 8:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> >> I'll do a quick respin of the patches with that and the
>> >> hwspinlock_internal.h comment above.
>> >
>> > OK..
>> >
>> > The patch series looks OK to me.
>>
>> Can I add your Acked-by on the non-omap parts when I respin the series ?
>
> spose so.  I don't normally do acked-by's.  I think it's my way of
> avoiding getting blamed when it all blows up.

I don't want to be breaking old habits then :)

>> > Maybe Tony or Russell or Greg can grab them
>> > if they like the look of it all?

Let's just wait a bit for Tony's or Russell's or Greg's answer.

Thanks,
Ohad.
