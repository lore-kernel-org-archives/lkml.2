Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab2J3VEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:04:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37694 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544Ab2J3VE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:04:26 -0400
Date: Tue, 30 Oct 2012 22:04:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tostatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86, add hypervisor name to dump_stack() [v4]
Message-ID: <20121030210423.GA8024@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
	Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Marcelo Tostatti <mtosatti@redhat.com>,
	Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org, x86@kernel.org
References: <1351628793-27180-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351628793-27180-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 04:26:33PM -0400, Prarit Bhargava wrote:
> Debugging crash, panics, stack trace WARN_ONs, etc., from both virtual and
> bare-metal boots can get difficult very quickly.  While there are ways to
> decipher the output and determine if the output is from a virtual guest,
> the in-kernel hypervisors now have a single registration point
> and set x86_hyper.  We can use this to output additional debug
> information during a panic/oops/stack trace.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Marcelo Tostatti <mtosatti@redhat.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: kvm@vger.kernel.org
> Cc: x86@kernel.org
> 
> [v2]: Modifications suggested by Ingo and added changes for similar output
>       from process.c
> 
> [v3]: Unify common code and move output to end of line

Looks useful.

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.
