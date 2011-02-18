Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1BROek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:34:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60397 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416Ab1BROeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:34:37 -0500
Date: Fri, 18 Feb 2011 14:35:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 13/13] tty: pruss SUART driver
Message-ID: <20110218143500.23b3044b@lxorguk.ukuu.org.uk>
In-Reply-To: <90BDE50764124CA8AAD560BB1E92C062@subhasishg>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>
	<1297435892-28278-14-git-send-email-subhasish@mistralsolutions.com>
	<20110211162814.6ff274f1@lxorguk.ukuu.org.uk>
	<90BDE50764124CA8AAD560BB1E92C062@subhasishg>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 19:17:38 +0530
"Subhasish Ghosh" <subhasish@mistralsolutions.com> wrote:

> Hello,
> 
> Regarding the semaphore to mutex migration.
> We are using down_trylock in interrupt context,
> mutex_trylock cannot be used in interrupt context, so we cannot use mutex in 
> our driver.

Then you probably need to rework your locking. Best bet might be to fix
all the other stuff and report the driver, and people can think about the
locking problem.

Alan
