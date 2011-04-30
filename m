Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab1D3KY5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 06:24:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42892 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755164Ab1D3KYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 06:24:55 -0400
Date: Sat, 30 Apr 2011 11:25:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v4 3/3] Introduce CONFIG_GOOGLE_FIRMWARE
Message-ID: <20110430112549.3c70d6e7@lxorguk.ukuu.org.uk>
In-Reply-To: <20110429225601.22013.92629.stgit@mike.mtv.corp.google.com>
References: <20110429212328.GA19207@kroah.com>
	<20110429225601.22013.92629.stgit@mike.mtv.corp.google.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 15:56:02 -0700
Mike Waychison <mikew@google.com> wrote:

> In order to keep Google's firmware drivers organized amongst themselves,
> all Google firmware drivers are gated on CONFIG_GOOGLE_FIRMWARE=y, which
> defaults to 'n' in the kernel build.

All 3 Acked-by: Alan Cox <alan@linux.intel.com>

> +	  These firmware drivers are used by Google's servers.  They are
> +	  only useful if you are working directly on one of their
> +	  proprietary servers.  If in doubt, say "N".

[or until people start adding them to other devices!]

Alan
