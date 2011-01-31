Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1AaVtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:49:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40620 "EHLO
	localhost6.localdomain6" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756583Ab1AaVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:49:06 -0500
Date: Mon, 31 Jan 2011 21:48:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        stable <stable@kernel.org>
Subject: Re: [PATCH 3/5] serial: unbreak billionton CF card
Message-ID: <20110131214854.3bb53bd4@pyx>
In-Reply-To: <1296491470-23096-3-git-send-email-gregkh@suse.de>
References: <20110131162852.GA22875@kroah.com>
	<1296491470-23096-3-git-send-email-gregkh@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; i686-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 08:31:08 -0800
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> From: Pavel Machek <pavel@ucw.cz>
> 
> Unbreak Billionton CF bluetooth card. This actually fixes a regression
> on zaurus.

It also unbreaks a pile of other chips.

Properly this should be a revert of  commit
7a56aa45982bb87bfca98a2832b5ae782c03364a as far as I can see.

