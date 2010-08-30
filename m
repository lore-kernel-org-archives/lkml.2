Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0H3Kg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 06:36:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33764 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754922Ab0H3Kg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 06:36:26 -0400
Date: Mon, 30 Aug 2010 11:54:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] tty/hw: move hardware drivers to drivers/tty/hw
Message-ID: <20100830115428.24e76ae5@lxorguk.ukuu.org.uk>
In-Reply-To: <201008301055.49600.arnd@arndb.de>
References: <1283115995-4734-1-git-send-email-arnd@arndb.de>
	<1283115995-4734-5-git-send-email-arnd@arndb.de>
	<AANLkTinE6E47=NbdWo28i6Z6i-6QqHUmF1+Tr7u_v8o3@mail.gmail.com>
	<201008301055.49600.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BTW, the bfin_jtag_comm.c looks less obsolete than the rest of those
> drivers, so I wasn't completely sure whether or not to move it into
> the same place as the others.

bfin_jtag is current

> My impression was that it should actually be converted into an hvc
> driver as a cleanup and moved to drivers/tty/hvc. It can probably
> get reduced to one third of its size if you do that.

Not sure it makes sense - hvc seems the wrong abstraction.

Alan
