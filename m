Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2D3X34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:29:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54147 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757311Ab2D3X3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:29:55 -0400
Date: Tue, 1 May 2012 00:30:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: kernelnewbies <Kernelnewbies@kernelnewbies.org>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Subject: Re: tty driver
Message-ID: <20120501003037.0fd545b8@pyramind.ukuu.org.uk>
In-Reply-To: <CALyraeMbrFy6v-n=kFJBvxBNqB7eFVCPeBfjTNvg32rCBk8ynw@mail.gmail.com>
References: <CALyraeMbrFy6v-n=kFJBvxBNqB7eFVCPeBfjTNvg32rCBk8ynw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2012 14:17:30 -0400
Sri Ram Vemulpali <sri.ram.gmu06@gmail.com> wrote:

> Hello All,
> 
> I am working on paging feature on tty, pty outputting. Is there anyway
> I can do paging output at tty drivers by way of setting some options
> using ioctl or ....

Things like page dimensions and escape code management are userspace
handled in Linux. If you must fake it via a tty then I'd suggest you
write a pty/tty using app, if not then pipe it through more.

For the former case a simple expect script should do it.
