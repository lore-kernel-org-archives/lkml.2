Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2A3UgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:36:24 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36782 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2A3UgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:36:23 -0500
Date: Mon, 30 Jan 2012 20:37:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, alan@linux.intel.com,
        jirislaby@gmail.com
Subject: Re: [PATCH 4/5] TTY: pty, remove superfluous ptm test
Message-ID: <20120130203744.16483d19@pyramind.ukuu.org.uk>
In-Reply-To: <1327954472-26594-4-git-send-email-jslaby@suse.cz>
References: <1327954472-26594-1-git-send-email-jslaby@suse.cz>
	<1327954472-26594-4-git-send-email-jslaby@suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 21:14:31 +0100
Jiri Slaby <jslaby@suse.cz> wrote:

> The code looks like:
> if (tty->driver->subtype == PTY_TYPE_MASTER) {
>   ...
>   if (tty->driver == ptm_driver)
> 
> But the second if is superfluous because only the ptm_driver is of
> PTY_TYPE_MASTER subtype.
> 
> Also we can remove the #if now because devpts_pty_kill is defined as
> an empty function for non-CONFIG_UNIX98_PTYS configs.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>

Acked-by: Alan Cox <alan@linux.intel.com>
