Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab1HYRn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:43:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904Ab1HYRnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:43:25 -0400
MIME-Version: 1.0
In-Reply-To: <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
 <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
 <20110825164649.GL2803@mtj.dyndns.org> <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Aug 2011 10:43:01 -0700
Message-ID: <CA+55aFwaxzFJCjJc1=6utMq0WQmrP4COGEOQirqBLcmdTf=+rQ@mail.gmail.com>
Subject: Re: mtrr failure, 3.1-rc1
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Anders Eriksson <aeriksson@fastmail.fm>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:43 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
>
> I was able to reproduce the issue and tested the below patch. It looks
> good.
>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

Tejun, sign-off?

                   Linus
