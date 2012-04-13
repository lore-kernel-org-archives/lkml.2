Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2DMQAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 12:00:51 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60698 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab2DMQAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 12:00:50 -0400
Date: Fri, 13 Apr 2012 17:03:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pata_cs5536: DMI detection of broken PCs
Message-ID: <20120413170328.65231662@pyramind.ukuu.org.uk>
In-Reply-To: <CAH9NwWeOt3bbcpP98Q6A2iKSZwqD628iHHAgr_Oe-UgKkE=G5A@mail.gmail.com>
References: <CAH9NwWeOt3bbcpP98Q6A2iKSZwqD628iHHAgr_Oe-UgKkE=G5A@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there a way to backlist the old devices to not use UDMA at all? DMI
> would be a good idea for
> detecting old devices. Is something like this possible?

You can implement a filter method. Presumably the data sheet and errata
tell you what the problem is and how to detect it. That will be your
starting point.

Alan
