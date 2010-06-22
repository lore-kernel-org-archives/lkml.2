Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0FVPoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:44:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49820 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754185Ab0FVPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 11:44:17 -0400
Date: Tue, 22 Jun 2010 16:48:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v3] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
In-Reply-To: <20100622153457.GA5381@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
	<20100617091322.b7d21473.randy.dunlap@oracle.com>
	<4C1A7D61.8010900@redhat.com>
	<20100621122145.76ebd7ac.akpm@linux-foundation.org>
	<20100621194559.GI3217@redhat.com>
	<20100621130008.d3dc01a8.akpm@linux-foundation.org>
	<20100622153457.GA5381@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jun 2010 11:34:57 -0400
Don Zickus <dzickus@redhat.com> wrote:

> This patch is similar to Theordore Ts'o's TAINT_USER patch,
> linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.

This seems to have gone backwards

> This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
> to use.

As I said before - just mark some as 'reserved'

Giving it a specific meaning means it can't freely be used for many
things by many distributions


> +	printk(KERN_CRIT "UNSUPPORTED HARDWARE DEVICE: %s\n", msg);
> +	WARN_TAINT(1, TAINT_HARDWARE_UNSUPPORTED,
> +		   "Your hardware is unsupported.  Please do not report "
> +		   "bugs, panics, oopses, etc., on this hardware.\n");

And as already pointed out it's not unsupported hardware even in the case
you described

NAK
