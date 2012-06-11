Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab2FKMtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 08:49:36 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52595 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2FKMtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 08:49:35 -0400
Date: Mon, 11 Jun 2012 13:53:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Paul Bolle <pebolle@tiscali.nl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] delete seven tty headers
Message-ID: <20120611135306.537757d2@pyramind.ukuu.org.uk>
In-Reply-To: <4FD5E7B8.1020502@suse.cz>
References: <1339145808.25798.28.camel@x61.thuisdomein>
	<4FD1DB30.80307@suse.cz>
	<1339155706.25798.55.camel@x61.thuisdomein>
	<201206081403.16608.arnd@arndb.de>
	<4FD5E7B8.1020502@suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree (I wrote I doubt there are any users at all). But I would prefer
> going through the deprecation phase (adding a #warning) anyway. Removing
> the headers completely in a year, or maybe sooner is OK then.

I really see no point. Distributions are going to build against a set of
headers generated from a kernel, once at the time the distribution is
first assembled (eg the kernel-headers package in Fedora).

> I think this is too late. Distros would find this out after months and
> there will be no reason to re-add empty headers and backport them to
> stable trees in between at that time...

If it takes months to find out then they were not needed 8)

Alan
