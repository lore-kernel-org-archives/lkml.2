Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422804Ab2JXWeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:34:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54734 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422652Ab2JXWeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:34:16 -0400
Date: Thu, 25 Oct 2012 00:34:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: danielfsantos@att.net, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 03/10] compiler-gcc{3,4}.h: Use GCC_VERSION macro
Message-ID: <20121024223413.GA8828@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Josh Triplett <josh@joshtriplett.org>, danielfsantos@att.net,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	Daniel Santos <daniel.santos@pobox.com>,
	David Daney <david.daney@cavium.com>,
	David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Pavel Pisa <pisa@cmp.felk.cvut.cz>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>,
	David Rientjes <rientjes@google.com>
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com>
 <1351096441-12388-3-git-send-email-daniel.santos@pobox.com>
 <20121024190546.GA17945@liondog.tnic>
 <20121024214900.GA5925@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121024214900.GA5925@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:49:00PM -0700, Josh Triplett wrote:
> > I can't seem to recall so did we explain already why ">= 40100" instead
> > of "> 40000"?
> > 
> > I mean, it is the same, but still...
> 
> __GNUC_MINOR__ > 0 means __GNUC_MINOR__ >= 1, so that would allow 4.1 or
> newer.  However, GCC_VERSION > 40000 would also allow 4.0.n for n > 0.

Ah, sure. In that case

Acked-by: Borislav Petkov <bp@alien8.de>

Thanks.

-- 
Regards/Gruss,
    Boris.
