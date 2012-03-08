Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab2CHA6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:58:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab2CHA6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:58:38 -0500
Date: Wed, 7 Mar 2012 21:58:27 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Seebach <peter.seebach@windriver.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
        paulus@samba.org, peterz@infradead.org, dsahern@gmail.com,
        fweisbec@gmail.com, yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120308005827.GE18932@infradead.org>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
 <20120307203725.GA4333@elte.hu>
 <20120307151951.7e84adb6@wrlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307151951.7e84adb6@wrlaptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 07, 2012 at 03:19:51PM -0600, Peter Seebach escreveu:
> On Wed, 7 Mar 2012 21:37:25 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >    We *DONT* want to make APIs more fragile just to accomodate a
> >    rare, esoteric usecase!
> 
> I would view snprintf as an API which already exists.  If it's the
> wrong API, by all means, write a different one -- but I would suggest
> not using the same name for it.  If a function is going to be called
> snprintf, IMO it should have the semantics of snprintf.  If those are
> the wrong semantics (and they may well be), then I would say use a
> function which has the right semantics, and isn't named snprintf.

Right, its more a case of: Don't assume people do things you think are
reasonable, read carefully and follow the instructions.

At least it is not as  long as other EULAs, it is much, much shorter,
but managed to be just as non intuitive.

- Arnaldo
