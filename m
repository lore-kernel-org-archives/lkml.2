Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab2FHDKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:10:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56235 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2FHDKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:10:16 -0400
Date: Fri, 8 Jun 2012 05:10:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephane Eranian <eranian@google.com>,
        jolsa@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: perf user tool precise attribute broken in 3.5rc1+
Message-ID: <20120608031009.GV27374@one.firstfloor.org>
References: <20120607202355.GQ27374@one.firstfloor.org> <CABPqkBQ99PTsET6c_NPuioLUr_yto4x=6EBQ1K73N4ratHz48A@mail.gmail.com> <20120607205836.GT27374@one.firstfloor.org> <20120607212759.GD30641@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607212759.GD30641@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you sure the old one works? Perhaps it silently falls back to
> cpu-clock?

Yes i'm sure. I was actually debugging some kernel pebs code,
and had a heavily instrumented pebs code path and was first trying
to figure out what went wrong in the kernel, until I realized 
that the userland was broken.

Does :p work for anyone else?

BTW I hope the perf userland becomes more stable again. Recently I've had
far more trouble with the user binary than the kernel driver, which
is unusal.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
