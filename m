Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1F1KFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:05:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58755 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756496Ab1F1KEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:04:24 -0400
Date: Tue, 28 Jun 2011 11:06:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Jamie Iles <jamie@jamieiles.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH 4/7] serial/8250: move DWAP support to arch/mips
Message-ID: <20110628110642.3517cac8@lxorguk.ukuu.org.uk>
In-Reply-To: <1309211120-2803-5-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-5-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 23:45:17 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> Only one board uses the UPIO_DWAP iotype, and nothing uses
> the UPIO_DWAP32 iotype. It seems much cleaner to handle the
> DWAP quirk as a new port type, and move the serial_out
> accessor into the platform code. If more platforms start
> using the DWAP port, that function can be moved into a
> common location.

Half of this patch appears to be unrelated work on HUB6

Both halves look right but did you accidentally fold two patches
together ?
