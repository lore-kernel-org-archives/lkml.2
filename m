Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab1ADUnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:43:08 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:60625 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1ADUnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:43:07 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.227.56]
In-Reply-To: <20110104121921.3550dcfa.akpm@linux-foundation.org>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
 <AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
 <20101214170656.GA3832@kroah.com> <AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
 <20101216210837.GA22895@kroah.com> <AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
 <20101218005311.GE5941@atomide.com> <AANLkTikLuu+njQA_PRmS_q8zs_xpB2gsqh3oZQJkB_Cm@mail.gmail.com>
 <20110104121921.3550dcfa.akpm@linux-foundation.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 4 Jan 2011 22:42:46 +0200
Message-ID: <AANLkTi=iccy1f7i9PkMvYcXHyMtfnzhBGSANDxocboDN@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 10:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> > Acked-by: Tony Lindgren <tony@atomide.com>
>>
>> Can you please have a look at this patch set (see link no. [1] below) ?
>
> I looked - it looks reasonable.  This is exactly the wrong time to be
> looking at large new patchsets - please refresh, retest and resend
> after -rc1 is released?

Sure, thanks !
