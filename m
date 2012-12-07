Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422803Ab2LGQaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:30:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56629 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422762Ab2LGQaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:30:08 -0500
Date: Fri, 7 Dec 2012 16:34:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: Jeremy Allison <jra@samba.org>, Pavel Shilovsky <piastry@etersoft.ru>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, wine-devel@winehq.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Message-ID: <20121207163458.435f676a@pyramind.ukuu.org.uk>
In-Reply-To: <CAH2r5msoPiu7wz-HjnnqTxeBLVEQiMYSnLMaZ+dEr11j6Fo4Ew@mail.gmail.com>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121206194949.7ab20d56@pyramind.ukuu.org.uk>
	<20121206195752.GA18585@samba2>
	<CAH2r5msoPiu7wz-HjnnqTxeBLVEQiMYSnLMaZ+dEr11j6Fo4Ew@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I suspect that WINE would have the same need

Tricky - Wine needs to enforce this behaviour solely between Wine and
the file server, Trying to muck up non emulated local behaviour would be
a bad mistake.

One way perhaps to look at this is you want some tasks to be able to *opt
in* to this behaviour.

First however I think we need a much better description of the setup that
uses them and why it matters.
