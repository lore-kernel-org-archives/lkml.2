Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab1LGU4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:56:16 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55036 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757098Ab1LGU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:56:15 -0500
Date: Wed, 7 Dec 2011 20:54:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Colin Walters <walters@verbum.org>, LKML <linux-kernel@vger.kernel.org>,
        morgan@kernel.org, serue@us.ibm.com, dhowells@redhat.com,
        kzak@redhat.com
Subject: Re: chroot(2) and bind mounts as non-root
Message-ID: <20111207205459.031a0609@lxorguk.ukuu.org.uk>
In-Reply-To: <4EDFCDD4.2080603@zytor.com>
References: <1323280461.10724.13.camel@lenny>
	<4EDFCDD4.2080603@zytor.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Dec 2011 12:34:28 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 12/07/2011 09:54 AM, Colin Walters wrote:
> > 
> > The historical reason one can't call chroot(2) as non-root is because of
> > setuid binaries (hard link a setuid binary into chroot of your choice
> > with trojaned libc.so).
> 
> No.  The historical reason is that it lets anyone escape a chroot jail:

Beg to differ

Nobody ever considered chroot a jail except a certain brand of
urban-legend-programming people. Indeed chroot has never been a jail
except in the 'open prison' security sense of it.

The big problem with chroot was abusing setuid binaries - particularly
things like uucp and /bin/mail.


