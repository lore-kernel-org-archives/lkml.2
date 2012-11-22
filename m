Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2KVTHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:07:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40172 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2KVTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:07:25 -0500
Date: Thu, 22 Nov 2012 14:42:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v6 6/9] bug.h: Prevent double evaulation of in
 BUILD_BUG_ON
Message-ID: <20121122134250.GC17147@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
	Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
 <1353445507-7233-6-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353445507-7233-6-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 03:05:04PM -0600, danielfsantos@att.net wrote:
> When calling BUILD_BUG_ON in an optimized build using gcc 4.3 and later,
> the condition will be evaulated twice, possibily with side-effects.
> This patch eliminates that error.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
