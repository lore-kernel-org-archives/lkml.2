Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0HBWRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:17:11 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:16823
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751550Ab0HBWRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:17:09 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
Date: Mon, 2 Aug 2010 17:16:54 -0500
From: Scott Wood <scottwood@freescale.com>
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Kumar Gala <kumar.gala@freescale.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Please pull my perf.git urgent branch
Message-ID: <20100802171654.1776759c@schlenkerla.am.freescale.net>
In-Reply-To: <20100728044731.GA2408@brick.ozlabs.ibm.com>
References: <20100727124019.GB14947@brick.ozlabs.ibm.com>
	<20100727112854.7bf97d48@schlenkerla.am.freescale.net>
	<20100728044731.GA2408@brick.ozlabs.ibm.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Aug 2010 22:16:56.0600 (UTC) FILETIME=[6B3C8980:01CB3290]
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 14:47:31 +1000
Paul Mackerras <paulus@samba.org> wrote:

> On Tue, Jul 27, 2010 at 11:28:54AM -0500, Scott Wood wrote:
> 
> > Doesn't the setting of .period need to be maintained (it is in the other
> > powerpc perf_event implementation that this is derived from)?
> 
> Gah, yes it does.

Well, looks like Linus pulled anyway...  I'll send a patch to
add .period.

-Scott

