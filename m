Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab0JVH7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:59:44 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39015 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab0JVH7n convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Fri, 22 Oct 2010 03:59:43 -0400
Message-Id: <4CC1549C020000780001E89A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 22 Oct 2010 08:08:44 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        <hpa@linux.intel.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-tip-commits@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:x86/debug] x86, asm: Fix CFI macro invocations to
	 deal with shortcomings in gas
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com><tip-3234282f33b29d349bcada40204fc7c8fda7fe72@git.kernel.org>
 <20101021101605.GA21465@elte.hu>
 <1287696649.20421.1401306095@webmail.messagingengine.com>
In-Reply-To: <1287696649.20421.1401306095@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.10.10 at 23:30, "Alexander van Heukelum" <heukelum@fastmail.fm> wrote:
> It turns out to generate something like this:
>     printk ( ("<3>") "something");
> The extra parentheses here break the compile.
> 
> Change the sed-program to add the parentheses only for numbers.

Thanks!

Acked-by: Jan Beulich <jbeulich@novell.com>

