Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab0INTbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:31:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40539 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753655Ab0INTbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:31:03 -0400
Date: Tue, 14 Sep 2010 20:50:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>,
        linux-kernel@vger.kernel.org, greg@kroah.com, x86@kernel.org
Subject: Re: [PATCH v3 1/4] x86, mrst: make mrst_identify_cpu() inlne inside
 mrst.h
Message-ID: <20100914205044.03ba679b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100914175726.GD3822@elte.hu>
References: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
	<1284361736-23011-2-git-send-email-feng.tang@intel.com>
	<20100914144345.49e05674@linux.intel.com>
	<20100914175726.GD3822@elte.hu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 19:57:26 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Alan Cox <alan@linux.intel.com> wrote:
> 
> > On Mon, 13 Sep 2010 15:08:53 +0800
> > Feng Tang <feng.tang@intel.com> wrote:
> > 
> > > Otherwise there will be some compilation warning for those .c files 
> > > which include mrst.h
> > 
> > I've sent this to Ingo four or five times already and been ignored.
> 
> I did a search of my mbox for all mails containing 'mrst_identify_cpu', 
> and the one by Feng Tang sent yesterday is the only one - none from you. 
> Searched the spam folder and the separate lkml folder too.
> 
> So where are those 4-5 emails, got any link perhaps?

They went to your address and my logs show they hit Intel internally but
I can't really see beyond that - I've mailed you directly a different
email to try and work out where they vanished so if you see this and no
direct mail then that would explain much. If you see both but didn't see
the mail recently about SFI device creation from me then it's specific to
the stgit setup sent emails.

Alan
