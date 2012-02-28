Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2B1JP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:15:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:17115 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab2B1JP4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 28 Feb 2012 04:15:56 -0500
Message-Id: <4F4CA97F0200007800075205@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 28 Feb 2012 09:16:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] [GIT PULL][v3.3] x86: Fix up CFI for the
 nested NMI
References: <20120225173548.977089274@goodmis.org>
 <20120227073905.GB3397@elte.hu>
 <1330349016.25686.185.camel@gandalf.stny.rr.com>
 <20120228090638.GL21106@elte.hu>
In-Reply-To: <20120228090638.GL21106@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.02.12 at 10:06, Ingo Molnar <mingo@elte.hu> wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Mon, 2012-02-27 at 08:39 +0100, Ingo Molnar wrote:
>> > So either you do an obviously trivial patch that only adds 
>> > CFI annotations and nothing else, or I can pull these bits 
>> > into tip:x86/debug, for a v3.4 merge.
>> 
>> I'm fine with waiting for v3.4 before these changes get in.
> 
> Jan, is that fine with you?

Yes, absolutely (I never expected these changes to be proposed for
inclusion in 3.3, given that I didn't have the time to get them done
and submitted before -rc4).

Jan

