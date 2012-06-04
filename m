Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab2FDPzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:55:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43518 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2FDPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:55:41 -0400
Date: Mon, 4 Jun 2012 16:58:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 13/24] TTY: um/line, use tty from tty_port
Message-ID: <20120604165836.664abac5@pyramind.ukuu.org.uk>
In-Reply-To: <4FCCD44A.3090500@nod.at>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
	<1338809738-18967-14-git-send-email-jslaby@suse.cz>
	<4FCCA3A6.8080608@nod.at>
	<4FCCD224.1020307@suse.cz>
	<4FCCD44A.3090500@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Two days ago I did so but still faced the problems described here:
> https://lkml.org/lkml/2012/3/10/163

If you are running a Fedora like distro it's because the user space is
broken. At some point we are going to have to make them fix the userspace
not to sit with ttys held open.


Alan
