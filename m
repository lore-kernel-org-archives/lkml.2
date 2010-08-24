Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab0HXV7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 17:59:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48984 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755435Ab0HXV7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 17:59:47 -0400
Date: Tue, 24 Aug 2010 23:16:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Samo Pogacnik <samo_pogacnik@t-2.net>,
        linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
Message-ID: <20100824231641.33d5679b@lxorguk.ukuu.org.uk>
In-Reply-To: <20100824211016.GA7176@suse.de>
References: <1275175983.2122.42.camel@itpsd6lap>
	<1276123020.16010.97.camel@itpsd6lap>
	<20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	<1276291932.2154.45.camel@itpsd6lap>
	<20100621153858.444695c0@lxorguk.ukuu.org.uk>
	<1277244410.2195.47.camel@itpsd6lap>
	<20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	<1277462596.2143.101.camel@itpsd6lap>
	<20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	<1282683470.8020.66.camel@itpsd6lap>
	<20100824211016.GA7176@suse.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does this need to be a tty driver?  Why not a misc device?

So you can use it as a"console" (in the user space sense) tty device on
embedded devices which don't have a meaningful normal output subsystem.

Alan
