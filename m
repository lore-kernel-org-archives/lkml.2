Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab1KVQCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:02:33 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41818 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab1KVQCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:02:32 -0500
Date: Tue, 22 Nov 2011 08:02:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, kexec@lists.infradead.org,
        tim@edgecast.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix chunk range calculation
Message-ID: <20111122160208.GA3250@google.com>
References: <4EC491B3.705@redhat.com>
 <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
 <4EC4B60C.3030706@redhat.com>
 <1321548033.12208.12.camel@boudreau>
 <4EC61AB6.4090808@redhat.com>
 <4EC61B2A.7010000@redhat.com>
 <20111118185535.GA27152@google.com>
 <4EC9AD4F.3050404@redhat.com>
 <20111121170146.GD15314@google.com>
 <4ECB104C.3040801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB104C.3040801@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dave.

On Tue, Nov 22, 2011 at 11:00:28AM +0800, Dave Young wrote:
> > Maybe we can add comment there how it can be further simplified and
> > why things look more complicated than necessary?
> 
> I wonder if it's good to add something like CONFIG_PER_CPU_DEBUG?

Yeah, having more comprehensive sanity checks w/ CONFIG_PER_CPU_DEBUG
would be really nice.

> Anyway I have no strong opinion with this. I'm fine to either of adding
> comment and put it into debug around.

I mostly just don't want to lose the minimal but useful checks in the
phys conversion function.  Please feel free to improve it.

Thank you.

-- 
tejun
