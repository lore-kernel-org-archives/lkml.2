Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0KSM1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 07:27:17 -0500
Received: from service88.mimecast.com ([195.130.217.12]:56481 "HELO
	service88.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753680Ab0KSM1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 07:27:16 -0500
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 07:27:16 EST
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in
 validate_event()
From: Will Deacon <will.deacon@arm.com>
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: ralf@linux-mips.org, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        wuzhangjin@gmail.com, paulus@samba.org, mingo@elte.hu, acme@redhat.com
In-Reply-To: <AANLkTikdLqo0-jkLkY-jGxurKMnmv+gb0VWWDZu6TOwd@mail.gmail.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
	 <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
	 <AANLkTikdLqo0-jkLkY-jGxurKMnmv+gb0VWWDZu6TOwd@mail.gmail.com>
Date: Fri, 19 Nov 2010 12:05:05 +0000
Message-ID: <1290168306.8175.8.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 19 Nov 2010 12:05:07.0087 (UTC) FILETIME=[01B021F0:01CB87E2]
X-MC-Unique: 110111912051005301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 11:30 +0000, Deng-Cheng Zhu wrote:
> Ah, I see. Thanks for your explanation.
> 
> But by doing this, I think we need to modify validate_group() as well.
> Consider a group which has all its events either not for this PMU or in
> OFF/Error state. Then the last validate_event() in validate_group() does
> not work. Right? So, how about the following:

[...]

If none of the events are for this PMU, then our validate_group()
won't be called. If all the events are OFF/ERROR then I don't see
what's wrong with passing the validation.

Will



