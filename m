Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258Ab1LFNSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:18:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49635 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753899Ab1LFNSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:18:03 -0500
Date: Tue, 6 Dec 2011 13:17:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH -tip] x86: fix build without CONFIG_X86_MRST
Message-ID: <20111206131706.5491a5f2@lxorguk.ukuu.org.uk>
In-Reply-To: <20111206103103.GC15966@elte.hu>
References: <1323166702-12990-1-git-send-email-sgruszka@redhat.com>
	<20111206103022.434ebf6f@lxorguk.ukuu.org.uk>
	<20111206103103.GC15966@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Dec 2011 11:31:03 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > On Tue,  6 Dec 2011 11:18:22 +0100
> > Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > 
> > > Fix compilation error when compiled with CONFIG_X86_INTEL_MID and
> > > without CONFIG_X86_MRST:
> > > 
> > > arch/x86/built-in.o: In function `add_rtc_cmos':
> > > rtc.c:(.init.text+0x34bd): undefined reference to `__mrst_cpu_chip'
> > 
> > It really is INTEL_MID wide, but there were other problems 
> > with the way the INTEL_MID selection was done. Should be fixed 
> > with the patch I sent Ingo.
> 
> Hm, i didnt realize that it broke the build upstream as well. I 
> improved your changelog to indicate the build failure and also 
> cherry-picked it over from tip:x86/platform (v3.3 material) into 
> tip:x86/urgent (v3.2 fixes).

Nor me - thanks

I've sent you a follow up fix.

Alan
