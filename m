Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2FVNbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:31:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40543 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab2FVNbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:31:12 -0400
Date: Fri, 22 Jun 2012 14:34:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christopher Brannon <chris@the-brannons.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: keyboard.c: Remove locking from vt_get_leds.
Message-ID: <20120622143452.2e74c39d@pyramind.ukuu.org.uk>
In-Reply-To: <1340370994-6914-1-git-send-email-chris@the-brannons.com>
References: <1340370994-6914-1-git-send-email-chris@the-brannons.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012 08:16:34 -0500
Christopher Brannon <chris@the-brannons.com> wrote:

> There are three call sites for this function, and all three
> are called within a keyboard handler.
> kbd_event_lock is already held within keyboard handlers,
> so attempting to lock it in vt_get_leds causes deadlock.
> 
> Signed-off-by: Christopher Brannon <chris@the-brannons.com>

Acked-by: Alan Cox <alan@linux.intel.com>
