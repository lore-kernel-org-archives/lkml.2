Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab2IGNYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:24:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48312 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2IGNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:24:52 -0400
Date: Fri, 7 Sep 2012 14:29:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: khalasa@piap.pl (Krzysztof =?UTF-8?B?SGHFgmFzYQ==?=),
        linux-kernel@vger.kernel.org
Subject: Re: 3.4.10 N_GSM tty_io WARNING and lockup
Message-ID: <20120907142931.22c4ec5b@pyramind.ukuu.org.uk>
In-Reply-To: <m3sjauc7kh.fsf@intrepid.localdomain>
References: <m3k3w8g2m4.fsf@t19.piap.pl>
	<20120906140137.75ebe6ba@pyramind.ukuu.org.uk>
	<m3627qt7kn.fsf@t19.piap.pl>
	<m3sjauc7kh.fsf@intrepid.localdomain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2012 14:59:26 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> > In the meantime I've rebased to v3.5.3 and it started to work. Do you
> > think it is worth it investigating v3.4.10 at this point?
> 
> BTW I'm not sure if it's a known bug: I closed the /dev/ttyS0 with
> /dev/gsmmuxX still open, and then tried to set N_TTY ldisc on the
> master device. It didn't work so well :-(

That should be fixed in 3.7. It's unfixable until the lock splitting work
is merged.
