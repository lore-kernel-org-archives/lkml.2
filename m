Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445Ab2GYSyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:54:38 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51674 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GYSyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:54:35 -0400
Date: Wed, 25 Jul 2012 20:54:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>
Subject: Re: [PATCH 15/19] perf tools: use XSI-complaint version of
 strerror_r() instead of GNU-specific
Message-ID: <20120725185430.GA1662@gmail.com>
References: <1343238094-12481-1-git-send-email-acme@infradead.org>
 <1343238094-12481-16-git-send-email-acme@infradead.org>
 <20120725175459.GA4878@shutemov.name>
 <20120725182355.GD17355@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725182355.GD17355@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Wed, Jul 25, 2012 at 08:54:59PM +0300, Kirill A. Shutemov escreveu:
> > Could you take subject from updated patch? This one:
> > 
> > perf: fix strerror_r() usage
> 
> Sorry, missed that :-\ I think it was because you didn't send 
> the new patch on its own, but keeping the old subject line and 
> inlining the new patch at the end of the message, please do it 
> next time.
> 
> Ingo, what is your take on this, do you want me to fix this up 
> and resubmit?

I already pulled this one - the old title was usable as well so 
I don't think we want to rebase it just for that reason.

Thanks,

	Ingo
