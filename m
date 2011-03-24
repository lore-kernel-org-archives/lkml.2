Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab1CXRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:31:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:35931 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754572Ab1CXRbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:31:23 -0400
Date: Thu, 24 Mar 2011 12:30:20 -0500
From: Jack Steiner <steiner@sgi.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
	test_and_set_bit_lock if possible
Message-ID: <20110324173020.GA26761@sgi.com>
References: <201103241026.01624.knikanth@suse.de> <20110324085647.GI30812@elte.hu> <20110324145221.GC31194@aftab> <4D8B83DA02000078000381DE@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8B83DA02000078000381DE@vpn.id2.novell.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This cacheline bouncing was actually observed and measured
> on SGI UV systems, but I'm not certain we're permitted to publish
> that data. I'm copying the two SGI guys who had reported that
> issue (and the special case fix, which Nikanth simply generalized)
> to us, for them to decide.

We frequently run into the cacheline bouncing issues. I don't have
the data handy that you refer to, but feel free to publish it.

--- jack


