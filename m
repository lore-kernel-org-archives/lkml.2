Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab0HAXIW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 19:08:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41949 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab0HAXIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 19:08:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=a9iZmrqyJozJbEL16K9/sLpGAB0AvNPLzWyvzHIw4GtkFdUrpPElmakeO1I6w7lbv9
         LXp10YSoNjwbLtmY/vSN61u8k1c/dOMJQkI3ynMuzNN5MiOWmo2vj5ThYinLKNvsHZd8
         mkV4jWnQ6qY/VhqkF8ClOH318Sw43hGMRKJM4=
Date: Mon, 2 Aug 2010 01:08:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, nouveau@lists.freedesktop.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86,mmiotrace: add support for tracing STOS instruction
Message-ID: <20100801230811.GA5561@nowhere>
References: <20100731205101.GA5860@joi.lan> <20100801112303.3e9bea3e@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801112303.3e9bea3e@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 11:23:03AM +0300, Pekka Paalanen wrote:
> On Sat, 31 Jul 2010 22:51:01 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > Cc: Pekka Paalanen <pq@iki.fi>
> 
> I have not checked the correctness of this patch, but otherwise:
> Acked-by: Pekka Paalanen <pq@iki.fi>



Queued, thanks!

