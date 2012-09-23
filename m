Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab2IWPh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 11:37:59 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40802 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab2IWPh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 11:37:58 -0400
Date: Sun, 23 Sep 2012 16:42:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Question on /sys/class/tty/tty0/active
Message-ID: <20120923164253.39151bdb@pyramind.ukuu.org.uk>
In-Reply-To: <CAFLxGvxqdtE1Uyqib9Qwo4azCVQbh=3vc_xxeAfAqDQOAE-J+A@mail.gmail.com>
References: <CAFLxGvxqdtE1Uyqib9Qwo4azCVQbh=3vc_xxeAfAqDQOAE-J+A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2012 16:40:07 +0200
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> Hi!
> 
> I'm booting 3.6-rc6 using KVM and observe the following output:
> $ tty
> /dev/tty0
> $ cat /sys/class/tty/tty0/active
> tty1
> 
> Why does the active file say I'm on tty1?
> There is no tty1, I'm on tty0.
> (Also "who" reports tty0)

tty0 is the current vt, tty1 is a direct mapping to that vt.

So it looks correct to me.

