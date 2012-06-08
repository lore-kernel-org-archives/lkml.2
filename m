Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab2FHJQD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 05:16:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49419 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969Ab2FHJQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 05:16:01 -0400
Date: Fri, 8 Jun 2012 10:19:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete seven tty headers
Message-ID: <20120608101935.7b07b13d@pyramind.ukuu.org.uk>
In-Reply-To: <1339145808.25798.28.camel@x61.thuisdomein>
References: <1339145808.25798.28.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Jun 2012 10:56:48 +0200
Paul Bolle <pebolle@tiscali.nl> wrote:

> Commit 51c9d654c2def97827395a7fbfd0c6f865c26544 ("Staging: delete tty
> drivers") left seven headers unused: nothing in the tree includes them
> anymore. Two of those headers were still exported, but since nothing in
> the kernel actually uses the things those two headers provide, that
> seems pointless. Delete these seven tty headers too.
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Alan Cox <alan@linux.intel.com>

> 1) cdk.h, comstats.h, istallion.h, and stallion.h are still referenced
> in Documentation/ioctl/ioctl-number.txt and
> Documentation/magic-number.txt. Should those references be deleted too?

Probably - but the fact the ioctl numbers were used needs to remain to
avoid any bad reuses

Alan
