Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2LNLSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:18:55 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36775 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2LNLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:18:54 -0500
Date: Fri, 14 Dec 2012 11:23:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] ata: uncomment ata_timing for XFER_PIO_SLOW
Message-ID: <20121214112301.54cb4a8d@pyramind.ukuu.org.uk>
In-Reply-To: <20121214110137.9155.68183.stgit@zurg>
References: <20121214110137.9155.68183.stgit@zurg>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 15:01:37 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch uncomments ata timings for XFER_PIO_SLOW,
> otherwise ata_timing_find_mode() returns NULL and kernel crashes in
> pacpi_set_dmamode() after null-pointer dereference.

NAK please see the previous discussion of this and the correct fix to set
up the dma timings field properly when it isn't available (0xFF not 0x00)

Alan
