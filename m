Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab2AWVmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:42:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37190 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab2AWVmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:42:02 -0500
Date: Mon, 23 Jan 2012 21:43:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Torne (Richard Coles)" <torne@google.com>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
Message-ID: <20120123214318.7183775c@pyramind.ukuu.org.uk>
In-Reply-To: <CAEV-rjeC1NwbUwdmEEquGf7S8uttsW5hwTjF5nTC_JXY7=OC9A@mail.gmail.com>
References: <1327343540-30348-1-git-send-email-torne@google.com>
	<CAP=VYLqpUun0FtCs4VWDeLm-mAri=+UV3psRA12eVbV1So_c-Q@mail.gmail.com>
	<CAEV-rjeC1NwbUwdmEEquGf7S8uttsW5hwTjF5nTC_JXY7=OC9A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, is this just not going to be acceptable in any form? What about
> refactoring the existing drivers that do this so that this code
> doesn't need to be repeated in every driver, if that would help? I'd
> really quite like to get standard linux distros to be compatible with
> the Joggler, and this is one of the few changes that's actually needed
> (one way or another).

It ought to be about a ten line change in Red Hat/Fedora, you could also
do it generically for most distributions as a udev rule.

Alan
