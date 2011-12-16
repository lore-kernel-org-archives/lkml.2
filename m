Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab1LPSuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:50:39 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37362 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab1LPSud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:50:33 -0500
Date: Fri, 16 Dec 2011 18:50:04 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Sreedhara <sreedhara.ds@intel.com>,
        Jacob Pan <jacob.jun.pan@intel.com>
Subject: Re: linux-next: Tree for Dec 16 (intel_scu & abp_timer)
Message-ID: <20111216185004.6a59dab3@pyx>
In-Reply-To: <4EEB9F3E.7080609@xenotime.net>
References: <20111216170042.650147ec79e792dce950f6e3@canb.auug.org.au>
	<4EEB9F3E.7080609@xenotime.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 11:42:54 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> On 12/15/2011 10:00 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20111215:
> 
> 
> warning: (X86_MRST && X86_MDFLD) selects INTEL_SCU_IPC which has unmet direct dependencies (X86 && X86_PLATFORM_DEVICES && X86_MRST)

I sent Ingo a fix for part of this, and Matthew another one last week. I
have another fix I just need to check a few more build combinations to
follow and hopefully finish the shuffle of config names.

Alan

