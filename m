Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab2KHXax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:30:53 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45103 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab2KHXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:30:52 -0500
Date: Thu, 8 Nov 2012 19:22:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Chini, Georg (HP App Services)" <georg.chini@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] Kernel 3.5 to 3.7-rc4 / GMA500 / DPMS sometimes
 crashes system
Message-ID: <20121108192221.48907c04@pyramind.ukuu.org.uk>
In-Reply-To: <B3A09DD14C7DC341B8B4D309FE5DD1BE1515A4D4@G2W2525.americas.hpqcorp.net>
References: <B3A09DD14C7DC341B8B4D309FE5DD1BE1515A4D4@G2W2525.americas.hpqcorp.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> generally it takes 3 or 4 cycles to trigger the bug. Kernel 3.4.3 works fine.
> There are no messages in the logs. Any idea what might cause this or how I
> can debug it any further? I will supply more details on my setup if needed.
> Please CC me in your reply as I am not subscribed to the list.

If 3.4.3 works and 3.5 fails then that is a big help as it narrows the
possible range of causes down quite a bit.

Hardware info would be helpful here but I suspect it may be a case of
doing a set of test builds to identify the offending patch.

Also anything in the log might be helpful including doing the runs with
drm.debug=255 in the kernel command line to get full traces

Alan
