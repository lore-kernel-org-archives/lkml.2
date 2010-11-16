Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0KPO5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:57:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57670 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755751Ab0KPO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:57:19 -0500
Date: Tue, 16 Nov 2010 14:55:51 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Valdis.Kletnieks@vt.edu, Jesper Juhl <jj@chaosbits.net>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Bodo Eggert <7eggert@web.de>, Mandeep Singh Baines <msb@google.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101116145551.49c47df5@lxorguk.ukuu.org.uk>
In-Reply-To: <20101116140341.42561c84@schatten.dmk.lab>
References: <20101115093410.BEFD.A69D9226@jp.fujitsu.com>
	<20101114181905.bc5b44f9.akpm@linux-foundation.org>
	<20101115113238.BF06.A69D9226@jp.fujitsu.com>
	<alpine.DEB.2.00.1011150215460.2986@chino.kir.corp.google.com>
	<alpine.LNX.2.00.1011160027180.22346@swampdragon.chaosbits.net>
	<34565.1289866395@localhost>
	<20101116110310.1502de2a@lxorguk.ukuu.org.uk>
	<20101116140341.42561c84@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How does one mark it apropriately?
> The commit 51b1bd2 (oom: deprecate oom_adj tunable, see below) 
> added it to feature-removal-schedule.txt, a patch for
> Documentation/ABI has also been provided in the meantime, if i'm not
> mistaken. 

Yes - so why is it spewing crap, annoying users and trying to irritate
application authors. It's not 2012 yet.

