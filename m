Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab0ELBAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 21:00:55 -0400
Received: from mail.perches.com ([173.55.12.10]:2172 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0ELBAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 21:00:53 -0400
Subject: Re: [trivial PATCH] arch/x86: Remove unnecessary returns from void
 function()'s
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <trivial@kernel.org>
In-Reply-To: <4BE9F94A.9000907@zytor.com>
References: <1273624747.20514.316.camel@Joe-Laptop.home>
	 <4BE9F94A.9000907@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 18:00:52 -0700
Message-ID: <1273626052.20514.319.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 17:41 -0700, H. Peter Anvin wrote:
> On 05/11/2010 05:39 PM, Joe Perches wrote:
> > This patch removes from arch/x86/ all the unnecessary
> > return; statements that precede the last closing brace of
> > void functions.
> And the point of this is?
> I fail to see how this improves the clarity of the code one iota, and
> isn't anything but just churn.

Just naked consistency.

Most all kernel void functions don't use return before
the closing brace.

The good thing about code removal is it doesn't make
any impact on git blame.

Ignore it or not.  No worries to me.

