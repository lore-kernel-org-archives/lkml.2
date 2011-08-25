Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1HYSDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 14:03:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1HYSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 14:03:23 -0400
MIME-Version: 1.0
In-Reply-To: <4E568DD1.5010501@zytor.com>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
 <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
 <20110825164649.GL2803@mtj.dyndns.org> <1314294182.16133.19.camel@sbsiddha-desk.sc.intel.com>
 <CA+55aFwaxzFJCjJc1=6utMq0WQmrP4COGEOQirqBLcmdTf=+rQ@mail.gmail.com>
 <20110825174656.GN2803@mtj.dyndns.org> <4E568DD1.5010501@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Aug 2011 11:03:00 -0700
Message-ID: <CA+55aFzbzAvKxZSBxRgyF7BF9WSj7eXtd5VDD=R+FTmRwi3p4w@mail.gmail.com>
Subject: Re: [PATCH] mtrr: fix UP breakage caused during switch to stop_machine
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Anders Eriksson <aeriksson@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 11:00 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Linus, are you picking this up from email or should I put it in x86/urgent?

I took it directly,

                    Linus
