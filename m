Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab1KWLSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 06:18:00 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40068 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948Ab1KWLR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 06:17:59 -0500
Date: Wed, 23 Nov 2011 11:16:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] serial: Kconfig: drop unknown symbol
 'ARCH_IMX'
Message-ID: <20111123111635.0b57002a@lxorguk.ukuu.org.uk>
In-Reply-To: <1321963833.18752.3.camel@x61.thuisdomein>
References: <1321963833.18752.3.camel@x61.thuisdomein>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 13:10:33 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> Commit 8c8fdbc9bd ("[ARM] Remove arch-imx from build system") dropped
> ARCH_IMX. So this last reference to ARCH_IMX has been an
> (inconsequential) nop since v2.6.31. And because ARCH_MXC practically
> implies ARM we can also drop the reference to the latter symbol.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Alan Cox <alan@linux.intel.com>
