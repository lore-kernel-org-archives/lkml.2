Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab0IPVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 17:40:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52750 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752677Ab0IPVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 17:40:24 -0400
Date: Thu, 16 Sep 2010 23:01:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, drosenberg@vsecurity.com
Subject: Re: [PATCH 0/3] Fix the TIOCGICOUNT problem for good
Message-ID: <20100916230157.0c045cdd@lxorguk.ukuu.org.uk>
In-Reply-To: <20100916184446.GA8803@kroah.com>
References: <20100916171747.25987.33573.stgit@localhost.localdomain>
	<20100916184446.GA8803@kroah.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 11:44:46 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, Sep 16, 2010 at 06:21:06PM +0100, Alan Cox wrote:
> > Remembering to clear fields is something driver authors are simply never
> > going to remember to get right every new driver. Instead take the problem
> > away from them and give them a simple interface to do the job.
> 
> Looks good.  But is it ok if I keep the one driver patch I have now for
> .36 and queue this up for .37?  I'll handle the merge conflicts myself.

Probably sensible given the closeness of .36 and the scale of changes
