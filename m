Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759858Ab2HXRHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:07:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60340 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542Ab2HXRHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:07:40 -0400
Date: Fri, 24 Aug 2012 18:12:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Joe Millenbach <jmillenbach@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        team-fjord@googlegroups.com
Subject: Re: [PATCH] tty: Added a CONFIG_TTY option to allow removal of TTY
Message-ID: <20120824181221.5ed4511c@pyramind.ukuu.org.uk>
In-Reply-To: <20120824170342.GA9794@jtriplet-mobl1>
References: <1345499431-21658-1-git-send-email-jmillenbach@gmail.com>
	<20120821142047.777e4bb0@pyramind.ukuu.org.uk>
	<CADwDc1AvCvWbj8znN-1WbkZA9WYVAqaTkxi7+ENZfJ-qFNRAvw@mail.gmail.com>
	<CADwDc1BgCM9AA4T3mUxfOGNaNoYwERP-x4y2ZS4mAhfF-K_qzA@mail.gmail.com>
	<20120824141537.63274081@pyramind.ukuu.org.uk>
	<20120824170342.GA9794@jtriplet-mobl1>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > The true cause I think is that serio/serport.c should depend on tty to be
> > built but the ps/2 mouse bits shouldn't.
> 
> On the other hand, most people disabling CONFIG_TTY will be building an
> extreme embedded system, and on such a system a PS/2 mouse seems highly
> unlikely.  Given that, perhaps the goal of removing dependencies on TTY
> could happen incrementally once CONFIG_TTY exists?

Fine by me
