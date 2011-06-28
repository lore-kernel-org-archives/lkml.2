Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1F1KJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:09:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39535 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754475Ab1F1KIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:08:07 -0400
Date: Tue, 28 Jun 2011 11:10:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 6/7] serial/8250: sanitize fourport handling
Message-ID: <20110628111035.7bd69c0d@lxorguk.ukuu.org.uk>
In-Reply-To: <1309211120-2803-7-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-7-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 23:45:19 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> Support for AST fourport cards is always built into
> the 8250 driver, even if CONFIG_SERIAL_8250_FOURPORT
> is disabled. This introduces a set of macros for
> accessing the special interrupt control register on
> the fourport card, so that support is left out
> when the option is disabled, without adding more #ifdef
> lines to the driver itself.

Why not just leave it in - it seems to take almost no code and your
changes mean people setting the fourport flag are going to get strange
behaviour when it isn't compiled in.

