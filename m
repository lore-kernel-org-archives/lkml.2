Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1BHKP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:15:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58644 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752873Ab1BHKP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:15:57 -0500
Date: Tue, 8 Feb 2011 10:18:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] [PATCH] Clarify source code distribution requirements
Message-ID: <20110208101840.52ae59f5@lxorguk.ukuu.org.uk>
In-Reply-To: <1297120144-2142-1-git-send-email-mjg@redhat.com>
References: <1297120144-2142-1-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Feb 2011 18:09:04 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> Some vendors (such as http://users.livejournal.com/joshua_/43185.html)
> insist that since section 3(b) of GPLv2 does not contain an explicit
> timeframe for source distribution, they can ignore requests for source
> for up to 120 days. Clarify the introduction to the license to indicate
> that this isn't what's meant.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

1. You've put it so it as if Linus said it
2. I'd like to see a lawyers take on it first (Linux Foundation perhaps)
before it goes in

Unless it's been past someone with legal knowledge you risk making the
problem worse not better even when doing apparently sane things.

You may also be weakening things if the legal view is that there being no
timescale means that the two should be going out together.
