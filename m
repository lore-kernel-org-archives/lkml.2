Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab2ERPF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:05:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50461 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2ERPF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:05:57 -0400
Date: Fri, 18 May 2012 16:08:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NVM Mapping API
Message-ID: <20120518160834.6006c821@pyramind.ukuu.org.uk>
In-Reply-To: <20120518144922.GS22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com>
	<1337161920.2985.32.camel@dabdike.int.hansenpartnership.com>
	<20120516173523.GK22985@linux.intel.com>
	<1337248478.30498.24.camel@dabdike.int.hansenpartnership.com>
	<20120517185944.GP22985@linux.intel.com>
	<1337331833.2938.22.camel@dabdike.int.hansenpartnership.com>
	<20120518144922.GS22985@linux.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do think that using numbers to refer to regions of NVM is a complete
> non-starter.  This was one of the big mistakes of SYSV; one so big that
> even POSIX couldn't stomach it.

That basically degenerates to using UUIDs. Even then it's not a useful
solution because you need to be able to list the UUIDs in use and their
sizes which turns into a file system.

I would prefer we use names.

Alan
