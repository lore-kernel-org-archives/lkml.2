Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab2DCU4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:56:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49539 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab2DCU4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:56:17 -0400
Date: Tue, 3 Apr 2012 21:58:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sudhakar <sudhakar@fb.com>
Cc: <linux-serial@vger.kernel.org>, <alan@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <dan.j.williams@intel.com>,
        <nhan.h.mai@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]  8250_pci: Replace commits 448ac154 and e86ff4a
Message-ID: <20120403215832.0520f93d@pyramind.ukuu.org.uk>
In-Reply-To: <4F7B52D8.101@fb.com>
References: <4F7B52D8.101@fb.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 12:43:20 -0700
sudhakar <sudhakar@fb.com> wrote:

> 
> From: Sudhakar Mamillapalli <sudhakar@fb.com>
> 
> 
> The following commits don't completely fix the KT serial missing
> interrupt problems.  So they have been replaced instead by
> enabling serial backup timer.  The iir-once + msi tried approach tried
> to enforce one read of the iir per THRE event, but its defeated by any
> other event occurring at the wrong time, particularly MSR events.
> 
> 448ac15 serial/8250_pci: setup-quirk workaround for the kt serial controller
> e86ff4a serial/8250_pci: init-quirk msi support for kt serial controller

These are already in tree. If you are reversing them and adding a
different fix then please post the series as

- two revert patches exactly reverting the two commits
- a follow on patch or two adding the replacement

That makes it much easier to review and much more obvious. It also helps
make testing simpler.

Alan
