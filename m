Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2C1KoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:44:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49873 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab2C1KoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:44:12 -0400
Date: Wed, 28 Mar 2012 11:46:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Josh Boyer <jwboyer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
Message-ID: <20120328114627.51b64541@pyramind.ukuu.org.uk>
In-Reply-To: <4F72BBCE.1060307@zytor.com>
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
	<20120327162633.654c8d7e.akpm@linux-foundation.org>
	<CA+5PVA4KsG0CEs8MhEL2qQoLBU9M6xAoPX2qnTZJ2R5RQ7-osg@mail.gmail.com>
	<20120328064008.GA12735@gmail.com>
	<4F72BBCE.1060307@zytor.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2012 00:20:46 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/27/2012 11:40 PM, Ingo Molnar wrote:
> > 
> > No objections from me.
> > 
> > Please resubmit against latest -tip, we unified the idle 
> > routines which likely interacts with that patch.
> > 
> 
> To the best of my knowledge, no-hlt only existed because of flaky power
> distributions on 386/486 systems which were sold to run DOS.  Since DOS
> did no power management of any kind, including HLT, the power draw was
> fairly uniform; when exposed to the much higher noise levels you got
> when Linux used HLT caused some of these systems to fail.

Also for the Cyrix 5510 which tended to go castors up if a HLT occurred
during a DMA cycle and on a few other boxes HLT during DMA tended to go
astray.

Do we care ? I doubt it. The 5510 was pretty obscure, the 5520 fixed it,
the 5530 is probably the oldest still in any kind of use.

Alan


