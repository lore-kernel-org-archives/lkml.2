Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab0FGJUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 05:20:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36361 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733Ab0FGJUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 05:20:12 -0400
Subject: Re: mmotm 2010-06-03-16-36 lots of suspected kmemleak
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <AANLkTikXdy6GOQ2EzDt-yrcJ_jMIPvLsH3neWBozpVCK@mail.gmail.com>
References: <AANLkTikXdy6GOQ2EzDt-yrcJ_jMIPvLsH3neWBozpVCK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Ltd
Date: Mon, 07 Jun 2010 10:19:55 +0100
Message-ID: <1275902395.7258.9.camel@toshiba-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2010 09:19:56.0722 (UTC) FILETIME=[987DB120:01CB0622]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-07 at 06:20 +0100, Dave Young wrote:
> On Fri, Jun 4, 2010 at 9:55 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > On Fri, Jun 4, 2010 at 6:50 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> >> Dave Young <hidave.darkstar@gmail.com> wrote:
> >>> With mmotm 2010-06-03-16-36, I gots tuns of kmemleaks
> >>
> >> Do you have CONFIG_NO_BOOTMEM enabled? I posted a patch for this but
> >> hasn't been reviewed yet (I'll probably need to repost, so if it fixes
> >> the problem for you a Tested-by would be nice):
> >>
> >> http://lkml.org/lkml/2010/5/4/175
> >
> >
> > I'd like to test, but I can not access the test pc during weekend. So
> > I will test it next monday.
> 
> Bad news, the patch does not fix this issue.

Thanks for trying. Could you please just disable CONFIG_NO_BOOTMEM and
post the kmemleak reported leaks again?

Thanks.

-- 
Catalin

