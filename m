Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1EKQC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:02:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49021 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754226Ab1EKQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:02:27 -0400
Date: Wed, 11 May 2011 11:35:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
Cc: <davinci-linux-open-source@linux.davincidsp.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>,
        <nsekhar@ti.com>, <sachi@mistralsolutions.com>,
        "Andrew Morton \(commit_signer:1/4=25%\)" <akpm@linux-foundation.org>,
        "Randy Dunlap \(commit_signer:1/4=25%\)" <randy.dunlap@oracle.com>,
        "open list" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/11] tty: add pruss SUART driver
Message-ID: <20110511113546.4592af20@lxorguk.ukuu.org.uk>
In-Reply-To: <F0F0851DD515419B962AB1646D333CB1@subhasishg>
References: <1303474109-6212-1-git-send-email-subhasish@mistralsolutions.com>
	<1303474109-6212-9-git-send-email-subhasish@mistralsolutions.com>
	<034A6447E0D54737B5CEE009A4D20B37@subhasishg>
	<20110509144610.6b4f7090@lxorguk.ukuu.org.uk>
	<3A9C5CD56396439DBF825BB4E5779DB9@subhasishg>
	<20110509145534.2677dfa1@lxorguk.ukuu.org.uk>
	<F0818DA1343E4FF1B3096048359CCC4C@subhasishg>
	<20110510143243.3e6f4050@lxorguk.ukuu.org.uk>
	<F0F0851DD515419B962AB1646D333CB1@subhasishg>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We do not support Modem control signals. So, I use -clocal with stty,
> but I observe that still enable_ms and get_mctrl handlers get called.
> Is that normal, how can I disable these functions from getting called.

It is normal.

> Actually, this same driver works perfectly with 2.6.33 kernel.
> With this Kernel I do not observe that these handlers getting called.
> So, basically the code path is different.

Quite possibly - but you'll need to trace down and understand *why* the
problem exists. Finding which kernel introduces it might be a step in the
right direction.

Alan
