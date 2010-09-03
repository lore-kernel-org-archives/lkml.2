Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab0ICWFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 18:05:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65356 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab0ICWFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 18:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vfCnsE2LVOPZMWEMhNafOOImiBu1FsMvcMZSxwDGMgQ/A9is+ERXDxJDOJNSytkeTT
         ymPETrcZqlswMcLxkF9Kcn4zNL3pk6dcXcflrbp1W1+d8i2t/pAeKOWsTLIPaDOI3hJ1
         EvpFcuSESy7KnGyR2JjnE/mhezerrSuFe61ps=
MIME-Version: 1.0
In-Reply-To: <20100903134814.b7129f7b.akpm@linux-foundation.org>
References: <20100901121951.GC6663@tiehlicka.suse.cz>
	<20100901124138.GD6663@tiehlicka.suse.cz>
	<20100902144500.a0d05b08.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902082829.GA10265@tiehlicka.suse.cz>
	<20100902180343.f4232c6e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100902092454.GA17971@tiehlicka.suse.cz>
	<AANLkTi=cLzRGPCc3gCubtU7Ggws7yyAK5c7tp4iocv6u@mail.gmail.com>
	<20100902131855.GC10265@tiehlicka.suse.cz>
	<AANLkTikYt3Hu_XeNuwAa9KjzfWgpC8cNen6q657ZKmm-@mail.gmail.com>
	<20100902143939.GD10265@tiehlicka.suse.cz>
	<20100902150554.GE10265@tiehlicka.suse.cz>
	<20100903121003.e2b8993a.kamezawa.hiroyu@jp.fujitsu.com>
	<20100903165713.88249349.kamezawa.hiroyu@jp.fujitsu.com>
	<20100903134814.b7129f7b.akpm@linux-foundation.org>
Date: Sat, 4 Sep 2010 07:05:48 +0900
Message-ID: <AANLkTi=vr+eb1GPCc6b20wAn00TDS-Tf8Zu7Y7z7p7i2@mail.gmail.com>
Subject: Re: [PATCH 3/2][BUGFIX] fix memory isolation notifier return value check
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/4 Andrew Morton <akpm@linux-foundation.org>:
> On Fri, 3 Sep 2010 16:57:13 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>> Sorry, the 3rd patch for this set.
>
> What happened with "[PATCH 2/2] Make is_mem_section_removable more
> conformable with offlining code"?  You mentioned sending an updated
> one, but I can't immediately find it.
>
Sorry, I couldn't. (and I will not able to do until Monday.)

> Also, please do describe the impact of the problems which are being
> fixed.  It helps me decide on priority and on
> which-kernels-need-the-patch and it helps others when deciding
> should-i-backport-this-into-my-kernel.
>
Ah,yes
  - Before the patch [2/2], the code is buggy but works.
    (Because of not-precise test of pre-memory-hotplug.)

    IOW, patch [2/2] is not buggy but make the bug  be apparent and
    evenryone will hit this.

    Influence is very small and maybe no need for backport.


> I think it'd be best to resend all of this, please.
>
I'll do in the next week. Sorry for annoying.

Thanks,
-Kame
