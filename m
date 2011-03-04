Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759544Ab1CDMmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 07:42:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46498 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884Ab1CDMma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 07:42:30 -0500
Date: Fri, 4 Mar 2011 12:39:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Steffen Sledz <sledz@dresearch.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Mario Schuknecht <m.schuknecht@dresearch.de>
Subject: Re: [PATCH v2] tcp: ioctl type SIOCOUTQNSD returns amount of data
 not sent
Message-ID: <20110304123950.2c91ebd9@lxorguk.ukuu.org.uk>
In-Reply-To: <4D70DA8D.9070603@dresearch.de>
References: <201103041057.53671.arnd@arndb.de>
	<1299234031-13937-1-git-send-email-sledz@dresearch.de>
	<4D70DA8D.9070603@dresearch.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If you plan to add one to Linux then please post the accompanying *tty
> > layer* patches and reasoning, otherwise if it is socket only please stick
> > to the socket ioctl.
> 
> So we should define the new SIOCOUTQNSD in sockios.h only and not similiar to SIOCOUTQ using TIOCOUTQ. Right?

Right

Alan
