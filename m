Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab0GLQsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:48:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56185 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751203Ab0GLQsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:48:16 -0400
Date: Mon, 12 Jul 2010 17:56:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?RnLpZOlyaWMgQnJp6HJl?= <fbriere@fbriere.net>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-parport@lists.infradead.org
Subject: Re: [PATCH] parport/serial: add support for Timedia/SUNIX cards to
 parport_serial
Message-ID: <20100712175649.59b06a9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20100712154448.GA2558@toroia.fbriere.dyndns.org>
References: <1277511823-6973-1-git-send-email-fbriere@fbriere.net>
	<20100708121122.17d3e823@lxorguk.ukuu.org.uk>
	<20100712154448.GA2558@toroia.fbriere.dyndns.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that I did not bother to cache the result of find_quirk(), so it
> will be called twice.  I did not find it worth to add extra complexity
> just for that; let me know if you disagree.

Without seeing the code its hard to be sure - but it sounds reasonable,
serial port loading isn't usually a hot benchmarking path 8)
