Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab2J1PRO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 11:17:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56845 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab2J1PRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 11:17:13 -0400
Date: Sun, 28 Oct 2012 15:22:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Stanislav Kozina <skozina@redhat.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 3.7-rc1
Message-ID: <20121028152216.2339f828@pyramind.ukuu.org.uk>
In-Reply-To: <508D033E.8030109@suse.cz>
References: <20121001183046.GA13042@kroah.com>
	<506A0FCA.2020908@suse.cz>
	<20121001221350.GA10172@kroah.com>
	<508D033E.8030109@suse.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2012 11:04:46 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> On 10/02/2012 12:13 AM, Greg KH wrote:
> > On Mon, Oct 01, 2012 at 11:48:58PM +0200, Jiri Slaby wrote:
> >> On 10/01/2012 08:30 PM, Greg KH wrote:
> >>> Stanislav Kozina (2):
> >>>       tty: Fix possible race in n_tty_read()
> >>
> >> The (pretty hopeless) commit log says:
> >>     Fix possible panic caused by unlocked access to tty->read_cnt in
> >>     while-loop condition in n_tty_read().
> >>
> >> Just curious, what kind of panic that can cause, can you be more
> >> concrete on that? I suppose two readers, one eats everything, the other
> >> is a killer? And should we backport to -stable?
> > 
> > Stanislav, you are the one who could reproduce this, any answers here?
> 
> Ping?

Thread here

http://permalink.gmane.org/gmane.linux.serial/8365
