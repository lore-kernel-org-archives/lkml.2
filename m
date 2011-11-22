Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683Ab1KVQT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:19:29 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40793 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756822Ab1KVQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:19:28 -0500
Date: Tue, 22 Nov 2011 08:19:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, kexec@lists.infradead.org,
        tim@edgecast.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix chunk range calculation
Message-ID: <20111122161922.GC3250@google.com>
References: <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>
 <4EC491B3.705@redhat.com>
 <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
 <4EC4B60C.3030706@redhat.com>
 <1321548033.12208.12.camel@boudreau>
 <4EC61AB6.4090808@redhat.com>
 <4EC61B2A.7010000@redhat.com>
 <20111118185535.GA27152@google.com>
 <20111121211050.GK25776@google.com>
 <4ECB0D7C.1020700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECB0D7C.1020700@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 10:48:28AM +0800, Dave Young wrote:
> Tested-by: Dave Young <dyoung@redhat.com>

Thanks.  Applied to percpu/for-3.2-fixes with Tested-by added.

-- 
tejun
