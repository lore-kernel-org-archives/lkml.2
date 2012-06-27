Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2F0Ooy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:44:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50905 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756396Ab2F0Oox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:44:53 -0400
Message-ID: <1340808292.16533.46.camel@joe2Laptop>
Subject: Re: cosmetic printk() issue with lockdep warning in
 arch/x86/kernel/alternative.c
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>,
        Lennart Poettering <lennart@poettering.net>
Date: Wed, 27 Jun 2012 07:44:52 -0700
In-Reply-To: <CAPXgP117sDoiuA-i3LWFPnj+VN5BbOQrYGM8KXYCqGSan7ZZMg@mail.gmail.com>
References: <CAPXgP124qFG=QdO4H7qsp1bhY4BOp-PJEz7-4v-Dhi13LW+GDQ@mail.gmail.com>
	 <20120627060939.GD14913@gmail.com>
	 <CAPXgP10OLwd2v57qJqoJMTkXrM+7C8uhFoydy6HUEbfPfFVN8Q@mail.gmail.com>
	 <1340795162.10063.28.camel@twins>
	 <CAPXgP117sDoiuA-i3LWFPnj+VN5BbOQrYGM8KXYCqGSan7ZZMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 13:12 +0200, Kay Sievers wrote:
> Since yesterday, continuation lines (which are
> buffered) are flushed immediately to the console too.

Has Greg KH's boot hang been resolved?

