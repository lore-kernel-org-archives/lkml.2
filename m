Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2KACBh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 22:01:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64168 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2KACBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 22:01:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121101012546.GC26256@bbox>
References: <1351560594-18366-1-git-send-email-minchan@kernel.org>
 <20121031143524.0509665d.akpm@linux-foundation.org> <CAPM31RKm89s6PaAnfySUD-f+eGdoZP6=9DHy58tx_4Zi8Z9WPQ@mail.gmail.com>
 <CAHGf_=om34CQoPqgmVE5v8oVxntaJQ-bvFeEPMnfe_R+uvxqrQ@mail.gmail.com> <20121101012546.GC26256@bbox>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 31 Oct 2012 22:01:15 -0400
Message-ID: <CAHGf_=qm7HRLzhUHx7t3FmCAUmj0F7Vm6jaTGu_YwD+U-j58Aw@mail.gmail.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
To: Minchan Kim <minchan@kernel.org>
Cc: Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, sanjay@google.com,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - making zero page daemon and avoid pagesize zero fill at page fault
>> - making new vma or page flags and mark as discardable w/o swap and
>>   vmscan treat it. (like this and/or MADV_FREE)
>
> Thanks for the information.
> I realized by you I'm not first people to think of this idea.
> Rik already tried it(https://lkml.org/lkml/2007/4/17/53) by new page flag
> and even other OSes already have such good feature. And John's concept was
> already tried long time ago (https://lkml.org/lkml/2005/11/1/384)
>
> Hmm, I look over Rik's thread but couldn't find why it wasn't merged
> at that time. Anyone know it?

Dunno. and I like volatile feature than old one. but bold remark, please don't
100% trust me, I haven't review a detailed code of your patch and I don't
strictly understand it.
