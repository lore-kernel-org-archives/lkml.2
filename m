Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1ALOxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 09:53:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56493 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751248Ab1ALOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 09:53:15 -0500
Date: Wed, 12 Jan 2011 14:50:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Feng Tang <feng.tang@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] console: prevent registered consoles from dumping old
 kernel message over again
Message-ID: <20110112145009.352c3517@lxorguk.ukuu.org.uk>
In-Reply-To: <20110112225114.37d3b984@feng-i7>
References: <1294814926-1460-1-git-send-email-feng.tang@intel.com>
	<20110112111401.4879d928@bob.linux.org.uk>
	<20110112225114.37d3b984@feng-i7>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Don't know if I understand correctly, but with this patch all the consoles
> still will get the full version of kernel messages, it just save some
> console from dumping some of the early messages several times.
> 
> Still use the old example, assume log0 is the kernel messages from boot start to
> the point where tty1 get registered, log1 is from tty1's registering to
> ttyMFD2's, log2 is the rest kernel message. Before this patch, on the
> boot console, we will see: log0 + log0 + log1 + log0 + log1 + log2.

Sorry misunderstood the point of the patch - yes that makes sense !
