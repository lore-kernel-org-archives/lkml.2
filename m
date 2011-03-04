Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462Ab1CDL6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:58:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50400 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509Ab1CDL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:58:47 -0500
Date: Fri, 4 Mar 2011 11:58:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Matt Mackall <mpm@selenic.com>,
        cl@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make /proc/slabinfo 0400
Message-ID: <20110304115805.2e7d6917@lxorguk.ukuu.org.uk>
In-Reply-To: <2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
References: <1299174652.2071.12.camel@dan>
	<1299185882.3062.233.camel@calx>
	<1299186986.2071.90.camel@dan>
	<1299188667.3062.259.camel@calx>
	<1299191400.2071.203.camel@dan>
	<2DD7330B-2FED-4E58-A76D-93794A877A00@mit.edu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Being able to monitor /proc/slabinfo is incredibly useful for finding various
> kernel problems.  We can see if some part of the kernel is out of balance,

Making it 0400 doesn't stop that.

Alan
