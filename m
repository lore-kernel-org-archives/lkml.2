Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab1DUOWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:22:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45542 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab1DUOWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ti20s1oYzOXP/eFxCM+aRPcZSbRl9Xfi6yr5eWVNDu0LSMDjJEviP510QfdAOxTIy6
         GVk4j44APKCF+tgochXYHtqIRLK2RlIl0G+NR8iPI+GX4LU14IEMa7WAOHAvK2flMBa7
         Mr2W3C47rgMBei9SxHephorKKrl2KftgPDbuc=
MIME-Version: 1.0
In-Reply-To: <1303395603.2035.144.camel@laptop>
References: <BANLkTin_m2Ygnr8csKo6fJZ4sB6YYvYDGw@mail.gmail.com>
	<1303393450.2035.142.camel@laptop>
	<BANLkTinYu00M9No_Pqxp+gpEZAmPJPDt1g@mail.gmail.com>
	<1303395603.2035.144.camel@laptop>
Date: Thu, 21 Apr 2011 22:22:30 +0800
Message-ID: <BANLkTimNco7L+N0m_uwhWHE3vmXLfdeD0w@mail.gmail.com>
Subject: Re: [PATCH] sched: try to fix mm leak when freeing sched groups
From: Hillf Danton <dhillf@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 10:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2011-04-21 at 21:46 +0800, Hillf Danton wrote:
>>
>> It is linux-2.6.39-rc1.tar.bz2 downloaded at kernel.org, and
>>           >> --- a/kernel/sched.c  2011-03-30 03:09:48.000000000 +0800
>> is the time stamp, right?
>
> Dunno, but 39-rc1 is like ancient, please send patches against the tip
> git tree:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>

well, I will try it soon.

thanks
          Hillf
