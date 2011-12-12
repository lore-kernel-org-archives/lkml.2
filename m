Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab1LLKaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:30:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53375 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751386Ab1LLKad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:30:33 -0500
Date: Mon, 12 Dec 2011 10:31:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter martin <peter@naiadhome.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver
 because of worrying about possible misusage?
Message-ID: <20111212103120.0494405e@pyramind.ukuu.org.uk>
In-Reply-To: <4EE4FA4A.6030909@naiadhome.com>
References: <20111202231909.1ca311e2@lxorguk.ukuu.org.uk>
	<CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com>
	<4EDC9B17.2080701@gmail.com>
	<CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com>
	<4EDD01BA.40208@redhat.com>
	<4EDD2C82.7040804@linuxtv.org>
	<20111206112153.GC17194@sirena.org.uk>
	<4EDE0427.2050307@linuxtv.org>
	<20111206141929.GE17731@opensource.wolfsonmicro.com>
	<4EDE2B3B.2080905@linuxtv.org>
	<20111207134848.GB18837@opensource.wolfsonmicro.com>
	<4EDF71AE.5070509@linuxtv.org>
	<4EE4FA4A.6030909@naiadhome.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know enough about kernel modules doing networking, but do the 
> packets go through the iptables route, and do things like DSCP still get 
> taken note of?

If you go via the kernel tcp/ip stack then you'll get kernel iptables
rules, but you'd probably still want to add more security in many
environments, which means SSL which means user space and you are back to
not needing vtuner again.

Alan
