Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965Ab2COOwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:52:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab2COOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:52:08 -0400
Date: Thu, 15 Mar 2012 14:54:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, matt.fleming@intel.com
Subject: Re: [PATCH] EFI: Only set regions uncacheable if they support it
Message-ID: <20120315145406.7bd5d2a8@pyramind.ukuu.org.uk>
In-Reply-To: <20120315144236.GB4650@srcf.ucam.org>
References: <1331819798-1955-1-git-send-email-mjg@redhat.com>
	<4F61F5E6.8060509@zytor.com>
	<20120315140708.GA3395@srcf.ucam.org>
	<4F61FA14.6020203@zytor.com>
	<20120315142445.GA4357@srcf.ucam.org>
	<4F61FC8E.8070109@zytor.com>
	<20120315143308.GA4382@srcf.ucam.org>
	<4F61FE7E.9060600@zytor.com>
	<20120315144236.GB4650@srcf.ucam.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2012 14:42:36 +0000
Matthew Garrett <mjg@redhat.com> wrote:

> On Thu, Mar 15, 2012 at 07:36:46AM -0700, H. Peter Anvin wrote:
> 
> > I would still really like to understand why we're seeing #MCs... that's
> > bothersome all by itself.
> 
> The region is the legacy video RAM, so I can imagine there being 
> something magic about it.

What hardware platforms are afflicted by this btw ?
