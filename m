Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993195Ab2KOKhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:37:50 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54002 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992441Ab2KOKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:37:48 -0500
Date: Thu, 15 Nov 2012 10:42:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] TTY: memory leaks patchset
Message-ID: <20121115104254.3029bca9@pyramind.ukuu.org.uk>
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This series should go upstream regardless "TTY: move tty buffers to
> tty_port" if we decide to revert that commit due to the reported
> warnings I cannot reproduce and neither catch the root cause.

They seem to be warnings only and very obscure cases. I'd favour that
patch not being reverted simply because the only way we'll find a pattern
is by a lot more reports - and it doesn't seem to be anything but an
annoying log splat.

Alan
