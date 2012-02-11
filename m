Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab2BKOFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 09:05:14 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57879 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab2BKOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 09:05:13 -0500
Date: Sat, 11 Feb 2012 14:06:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hillf Danton <dhillf@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Subject: Re: [PATCH 3/6] sep: Add interfaces for the new functions
Message-ID: <20120211140639.7018024f@pyramind.ukuu.org.uk>
In-Reply-To: <CAJd=RBCWCinPwnqeXwm5P0zecbe3o1T+10xNSttfvYMN0feu0Q@mail.gmail.com>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
	<20120210135253.12442.95497.stgit@bob.linux.org.uk>
	<CAJd=RBAYtrQZBB3LHX=9xFru=r1XAuZrm1kL1siMKvBmCuuO9A@mail.gmail.com>
	<20120210164529.44e5e7db@pyramind.ukuu.org.uk>
	<CAJd=RBCWCinPwnqeXwm5P0zecbe3o1T+10xNSttfvYMN0feu0Q@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> why is EINVAL used then instead of -EINVAL?
> 
> Is this error case anything special from the above?
> I guess it is typo.

Thanks - now it makes sense.
