Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab0LJAaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 19:30:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59183 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756298Ab0LJAaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 19:30:03 -0500
Date: Fri, 10 Dec 2010 00:29:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ltuikov@yahoo.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
Message-ID: <20101210002918.414e6727@lxorguk.ukuu.org.uk>
In-Reply-To: <463402.63193.qm@web31809.mail.mud.yahoo.com>
References: <20101209205820.GA6014@xanatos>
	<463402.63193.qm@web31809.mail.mud.yahoo.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The only people who benefit from this patch are the people
> > "in the know"
> > about which hosts are buggy, not normal Linux users.
> 
> The OS might want to limit the number of streams for reasons other than a buggy HC. So this module parameter add flexibility other than making a buggy HC work.

Not of any use to anyone. Any stream limit stuff neees to b done
automatically otherwise it'll be of value to maybe 1 person if that.
It'll also never get tested so will in time rot, produce weird bugs or
show up locking horrors.


Alan
