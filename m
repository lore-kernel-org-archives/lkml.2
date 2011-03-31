Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1CaJ03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:26:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49836 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752485Ab1CaJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:26:27 -0400
Date: Thu, 31 Mar 2011 10:23:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/9] x86 idle: remove NOP cpuinfo_x86.hlt_works_ok flag
Message-ID: <20110331102355.17d30a38@lxorguk.ukuu.org.uk>
In-Reply-To: <20110331081800.GH5938@elte.hu>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
	<b048802b0285a5ff28e74a4309d833116174904a.1301550524.git.len.brown@intel.com>
	<20110331061247.GA24786@elte.hu>
	<alpine.LFD.2.02.1103310252160.8569@x980>
	<20110331081800.GH5938@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do we know whether a distro adds this to the boot line? Do we know about users 
> relying on it.

I certainly had hardware that needed it. Don't any more but this is more
trying to rip out stuff without letting nature take its course.

It's a trivial feature item.

> > Do we really need both?
> 
> Probably not, as i said i do not disagree - i just think it should be more 
> explicit. Make it a: "users of CPU models X beware" commit title, not 'remove 
> inactive code' ...

Just make the one config variable respond to both boot configuration
options. The parser is __init code anyway so discarded so the actual code
cost of compatibility is exactly NIL.

Alan
