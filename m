Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab1BRH7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:59:01 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:42806 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab1BRH67 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 18 Feb 2011 02:58:59 -0500
Message-Id: <4D5E350602000078000329C7@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 18 Feb 2011 07:59:50 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86: don't call dump_stack() from
	 arch_trigger_all_cpu_backtrace_handler()
References: <4D5D512902000078000326EE@vpn.id2.novell.com>
 <20110218074436.GH11404@elte.hu>
In-Reply-To: <20110218074436.GH11404@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 18.02.11 at 08:44, Ingo Molnar <mingo@elte.hu> wrote:

> * Jan Beulich <JBeulich@novell.com> wrote:
> 
>> show_regs() already prints two(!) stack traces, [...]
> 
> That ought to get fixed as well, right?

Yes, I'm intending to send a patch for that as a follow-up.

Jan

