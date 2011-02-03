Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1BCV3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:29:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59797 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752967Ab1BCV3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:29:31 -0500
Date: Thu, 3 Feb 2011 21:31:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Brian D. McGrew" <brian@visionpro.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Memset very slow
Message-ID: <20110203213158.62baa54c@lxorguk.ukuu.org.uk>
In-Reply-To: <C9704572.4797C%brian@visionpro.com>
References: <C9704572.4797C%brian@visionpro.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, my question is, can someone explain to me what is going on here?  I am
> not convinced this is a kernel problem just because a new kernel fixed it;
> but, if there were changes related to this in the kernel, then what is the
> oldest version I should be looking at to fix my issues?

The newer kernel does several things that may be relevant - the obvious
one is that it rewrites and corrects MTRR data if it doesn't like what
the BIOS handed out. That would fit with dramatic slowdowns in memory
performance being fixed.
