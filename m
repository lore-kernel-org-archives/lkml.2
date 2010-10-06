Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab0JFK01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 06:26:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38928 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab0JFK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 06:26:26 -0400
From: Andi Kleen <andi@firstfloor.org>
To: dave@gnu.org
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, robert.richter@amd.com,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3\, Andreas" <Andreas.Herrmann3@amd.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC 0/3] Basic support for LWP
References: <1286212172-654419-1-git-send-email-hans.rosenfeld@amd.com>
	<alpine.LFD.2.00.1010042358520.2556@localhost6.localdomain6>
	<20101005145155.GD173@escobedo.osrc.amd.com>
	<1286304220.2065.0.camel@cowboy>
Date: Wed, 06 Oct 2010 12:26:19 +0200
In-Reply-To: <1286304220.2065.0.camel@cowboy> (Davidlohr Bueso's message of
	"Tue, 05 Oct 2010 14:43:40 -0400")
Message-ID: <87k4lvhb1w.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davidlohr Bueso <dave@gnu.org> writes:
>
> That would be the way to go, I don't think anyone wants yet another
> profiling userspace tool.

Why not? 

Are you saying innovation in profilers is dead and we're all only
allowed to use a single one now?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
