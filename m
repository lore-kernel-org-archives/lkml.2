Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703Ab2J3Vdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:33:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60361 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab2J3Vdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:33:43 -0400
Date: Tue, 30 Oct 2012 21:38:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lasse =?ISO-8859-1?B?S+Rya2vkaW5lbg==?= <ljkarkk2@cc.hut.fi>,
        linux-kernel@vger.kernel.org
Subject: Re: urandom is too slow
Message-ID: <20121030213850.7b987ddf@pyramind.ukuu.org.uk>
In-Reply-To: <20121030185403.GA5044@thunk.org>
References: <508FEA5A.7010406@cc.hut.fi>
	<20121030185403.GA5044@thunk.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you just want to wipe a disk, you shouldn't be using /dev/urandom for that
> purpose.

If you want to wipe a disk issue a security erase command via hdparm.
There is no guarantee that simply writing crap all over it will re-use
the same sectors of physical media, and for a flash drive it causes
massive wear and takes forever while a security erase is normally near
immediate.

Alan
