Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab2ISRAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:00:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61401 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2ISQ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:59:57 -0400
Date: Wed, 19 Sep 2012 09:57:19 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: Re: [PATCH v7 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120919165719.GB6316@lizard>
References: <20120913150133.GA16238@lizard>
 <20120917113750.GA28838@kroah.com>
 <50571ADF.3000406@windriver.com>
 <20120917125427.GA23516@kroah.com>
 <20120917153943.GA7510@lizard>
 <20120917155408.GA302@kroah.com>
 <5059B324.70409@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5059B324.70409@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 06:57:24AM -0500, Jason Wessel wrote:
[..]
> Other than 1, 2 and 7.   They all get:
> 
> Acked-by: Jason Wessel <jason.wessel@windriver.com>
> 
> I ran out of time to review things yesterday, but it is all reviewed now.
> After we get some more comments from Anton, we can move forward.

Thanks for reviews, Jason!

I'll implement all your suggestions soonish.

Cheers,

Anton.
