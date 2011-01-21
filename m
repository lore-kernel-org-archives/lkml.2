Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab1AUI4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:56:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34343 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751265Ab1AUI4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:56:21 -0500
Date: Fri, 21 Jan 2011 08:55:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Sutharshan Ramamoorthy / Prod" <srmt@cypress.com>
Cc: kernelnewbies@nl.linux.org, linux-kernel@vger.kernel.org, odc@cypress.com
Subject: Re: printk(KERN_x...) vs dev_x()
Message-ID: <20110121085526.4617abae@lxorguk.ukuu.org.uk>
In-Reply-To: <20110121062844.M9817@cypress.com>
References: <20110121062844.M9817@cypress.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At some places in the code, there is no valid 'dev' pointer to pass to
> dev_xx() macro, at such places is it ok to use printk(KERN_XXX...)?

pr_debug() is the equivalent you want. Ideally tweak the code so the dev
pointer is available. I know that right now is a bit of a problem in a
few cases (some tty stuff for example only just acquired a usable dev
pointer)

Alan
			-- Linus Torvalds
