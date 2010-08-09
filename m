Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0HIKnJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:43:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47214 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756076Ab0HIKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:43:07 -0400
Date: Mon, 9 Aug 2010 11:57:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]exit.c: support larger exit code
Message-ID: <20100809115735.0ca4951e@lxorguk.ukuu.org.uk>
In-Reply-To: <dlq4j7-0tp.ln1@chipmunk.wormnet.eu>
References: <14414B36FFA0F1418CB707361EAA199A0194FB16@CNBEEXC006.nsn-intra.net>
	<dlq4j7-0tp.ln1@chipmunk.wormnet.eu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There is probably a deeper reason as errno.h/errno-base.h all seem to be 
> one byte return codes too.  I'm starting to ponder if that top three 
> bytes are meant to carry some other information?

man 2 wait

and also note that int was 16bits in the times when Unix wait/exit
behaviour was formulated.

Alan
