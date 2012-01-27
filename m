Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2A0LjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 06:39:19 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42749 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2A0LjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 06:39:16 -0500
Date: Fri, 27 Jan 2012 11:40:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ryan Mallon <rmallon@gmail.com>
Cc: airlied@linux.ie, airlied@redhat.com, Alan Cox <alan@linux.intel.com>,
        ville.syrjala@linux.intel.com, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@linux.ie
Subject: Re: [RFC PATCH] gma500: Fix suspend/resume functions
Message-ID: <20120127114029.51c56bc6@pyramind.ukuu.org.uk>
In-Reply-To: <4F224408.2040208@gmail.com>
References: <4F224408.2040208@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jan 2012 17:28:24 +1100
Ryan Mallon <rmallon@gmail.com> wrote:

> Both the suspend and resume functions incorrectly set psbfb =
> to_psb_fb(NULL) outside of the loop over all of the framebuffers. Fix
> this by moving the assignment of psbfb inside the loop and removing the
> initialisation of fb.
> 
> Signed-off-by: Ryan Mallon <rmallon@gmail.com>

Yes that wants fixing

Acked-by: Alan Cox <alan@linux.intel.com>

