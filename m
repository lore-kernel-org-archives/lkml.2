Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab1CXXWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 19:22:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750851Ab1CXXWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 19:22:41 -0400
Date: Thu, 24 Mar 2011 23:20:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 14/21]drivers:staging Remove extra comma.
Message-ID: <20110324232036.78ded5cc@lxorguk.ukuu.org.uk>
In-Reply-To: <1300994819-30930-14-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
	<1300994819-30930-14-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011 12:26:52 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:

> The patch below removes an extra comma from various parts 
> of the kernel. Please have a look when you have time, and let
> me know if its legit or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Can you split the gma500 one out and send it my way instead of via
trivial/Greg otherwise it'll collide with some of the big cleanup work
going on I fear.

And ack for the 3 intel ones (langwell_gpio, max3110, intel_mid_battery)
to go in directly.
