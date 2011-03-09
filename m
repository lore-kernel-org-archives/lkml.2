Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1CIWAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:00:01 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44210 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529Ab1CIWAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:00:00 -0500
Date: Wed, 9 Mar 2011 21:59:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Hong Liu <hong.liu@intel.com>
Subject: Re: [PATCH, RESEND] Putting the device into runtime suspend after
 resume()/probe() is handled
Message-ID: <20110309215932.08183cfd@lxorguk.ukuu.org.uk>
In-Reply-To: <20110309134504.6d850802.akpm@linux-foundation.org>
References: <20110309123916.19908.78417.stgit@bob.linux.org.uk>
	<20110309134504.6d850802.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 13:45:04 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 09 Mar 2011 12:39:34 +0000
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> > From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> > To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
> > Subject: [PATCH, RESEND] Putting the device into runtime suspend after resume()/probe() is handled
> > Date: Wed, 09 Mar 2011 12:39:34 +0000
> > User-Agent: StGIT/0.14.3
> > 
> > From: Hong Liu <hong.liu@intel.com>
> > 
> > by the PM core and the device core code. No need to manually add them in
> > each single driver. And correct the runtime state in remove().
> > 
> > Signed-off-by: Hong Liu <hong.liu@intel.com>
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> 
> I'd merged this a while back but was awaiting info on why v1 had a
> cc:stable so the changelog could be updated to indicate why a -stable
> backport was needed.
> 
> I see that the cc:stable has been removed so that settles that.  But
> it's still unclear how serious the bugs-which-were fixed are.  Oh well,
> a bug's a bug.  I put it in my 2.6.38 queue anyway.

Don't think anything there is that important. Also anyone actually using
the driver would I'm pretty sure currently be running an Intel spun
kernel not a generic 2.6.older unless someone is also now relying on it
for another platform anyway.
