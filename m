Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab2JZOSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:18:52 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55392 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933147Ab2JZOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:18:50 -0400
Date: Fri, 26 Oct 2012 15:23:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] kfifo: round up the fifo size power of 2
Message-ID: <20121026152344.4e6053d5@pyramind.ukuu.org.uk>
In-Reply-To: <1351258786.10060.5.camel@wall-e>
References: <1351238218-22648-1-git-send-email-yuanhan.liu@linux.intel.com>
	<1351243827.8719.5.camel@wall-e>
	<20121026123321.GG2778@yliu-dev.sh.intel.com>
	<1351258786.10060.5.camel@wall-e>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMHO absent any reason to make the allocation change we should keep the
existing behaviour. Absent any reason to fiddle with the code we should
leave it alone.

It's delicate, tricky, tiny and works. Don't fiddle.

For the size question if the default behaviour is to pack them in
then a caller can do their own padding if they want it, for the reverse
case you propose as a change this ceases to be true.

Thus I would say the current API is right anyway.

Alan
