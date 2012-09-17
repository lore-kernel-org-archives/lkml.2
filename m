Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2IQKvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:51:37 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32963 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2IQKvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:51:35 -0400
Date: Mon, 17 Sep 2012 11:56:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephan Schreiber <info@fs-driver.org>
Cc: linux-ia64@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        679545@bugs.debian.org, jrnieder@gmail.com
Subject: Re: [RFC/PATCH] ia64, SR870, EFI bug breaks ata_piix, uninitialized
 ICH4 IDE EXBAR mem resource
Message-ID: <20120917115619.13d3a3cb@pyramind.ukuu.org.uk>
In-Reply-To: <20120916183914.Horde._TGALdjz9kRQVgCy6ATxxJA@webmail.df.eu>
References: <20120916183914.Horde._TGALdjz9kRQVgCy6ATxxJA@webmail.df.eu>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My only disagreement here would be putting it in the ia64 paths. If
someone does the same for x86-32 (and this is EFI so it'll presumbly
smell the same on all platforms) then we'll want the same.

Better I think to generically catch the 0/0 case.

Alan

