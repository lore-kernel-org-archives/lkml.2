Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab1K3HeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 02:34:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35266 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752216Ab1K3HeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 02:34:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/PJ8dUpcnPE/B+2rTRMOlHaVh2PLPKRSuRSDWYGA
	tfDbpCojYv60bp
Subject: Re: [PATCH RT] tasklet/rt: Prevent tasklets from going into
 infinite spin in RT
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        Clark Williams <williams@redhat.com>
In-Reply-To: <1322627551.17283.11.camel@marge.simson.net>
References: <1322618120.17003.104.camel@frodo>
	 <1322627551.17283.11.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 08:34:01 +0100
Message-ID: <1322638441.5677.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 05:32 +0100, Mike Galbraith wrote:
> On Tue, 2011-11-29 at 20:55 -0500, Steven Rostedt wrote:

> > I booted this patch against 3.0-rt stable, and it didn't crash ;)
> > Could you apply it and see if it fixes the hang that you've been seeing.
> 
> I'll most certainly be testing it too.

Tested-by: Mike Galbraith <efault@gmx.de>

The other me tested it too.  Coincidentally, he was having the same darn
problem with a fat enterprise config (on the same x3550 M3 too).

Tested-by: Mike Galbraith <mgalbraith@suse.de>

Thanks, I can now turn x3550 (by Pratt & Whitney) off for a bit.

	-Mike

