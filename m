Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab3ABR2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:28:21 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58853 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ABR2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:28:20 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyH63agfbf+pYNRGHaprPqAJF=F19GR6ASP_RhoyDGLdA@mail.gmail.com>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils>
 <0000013bfbfbb293-ccc455ed-2db6-46e2-8362-dc418bae0def-000000@email.amazonses.com>
 <CA+55aFyH63agfbf+pYNRGHaprPqAJF=F19GR6ASP_RhoyDGLdA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Jan 2013 09:27:58 -0800
X-Google-Sender-Auth: 3EzBEEYjL6lo8fYouqRWk6dxqno
Message-ID: <CA+55aFxx6dj1Uzr4gUw2o-xYWpTkhaQ6LBSGnp16GC35gHs0_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting memory
To: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 9:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, I do not know why Hugh took the true case, but I don't really
> imagine that it matters. So I'll take these two patches, but it would
> be good if you double-checked this, Hugh.

Oh, Hugh actually even mentioned it in the commit message. So never mind.

                Linus
