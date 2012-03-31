Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466Ab2CaUfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:35:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2CaUfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:35:14 -0400
Date: Sat, 31 Mar 2012 21:37:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [ 086/149] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120331213738.57a9649d@pyramind.ukuu.org.uk>
In-Reply-To: <20120331180317.GA10792@kroah.com>
References: <20120330194853.145065448@linuxfoundation.org>
	<4F76260C.7080005@gmx.de>
	<20120331180317.GA10792@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012 11:03:17 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Mar 30, 2012 at 09:30:52PM +0000, Florian Tobias Schandinat wrote:
> > Hi Greg,
> > 
> > On 03/30/2012 07:49 PM, Greg KH wrote:
> > > 3.2-stable review patch.  If anyone has any objections, please let me know.
> > 
> > the same as for 3.3: This patch would require exporting
> > 'pcibios_enabled' to not break building uvesafb as a module. As Alan did
> > not agree with this approach it is not suitable for stable as is.
> 
> Oops, sorry about that, now removed, thanks for letting me know.

Actually for the backport its probably the right thing to do - its
simple, clear and slightly ugly, but its fairly provably safe.
