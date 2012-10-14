Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab2JNMWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 08:22:20 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38416 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2JNMWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 08:22:19 -0400
Date: Sun, 14 Oct 2012 13:27:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Jan Kara <jack@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at fs/buffer.c:3205 (stable 3.5.3)
Message-ID: <20121014132714.7a869932@pyramind.ukuu.org.uk>
In-Reply-To: <507A8189.7020402@ahsoftware.de>
References: <50531629.9020107@ahsoftware.de>
	<20120925110206.GD28937@mwanda>
	<50643C4A.9010202@ahsoftware.de>
	<20120927151232.GA12210@quack.suse.cz>
	<506474E8.3030300@ahsoftware.de>
	<20120927200342.GB12553@quack.suse.cz>
	<506746EF.5070000@ahsoftware.de>
	<20121001091001.GA22800@quack.suse.cz>
	<506960AE.2000402@ahsoftware.de>
	<506AB426.4000407@ahsoftware.de>
	<507A8189.7020402@ahsoftware.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The people which are responsible that the chips for "consumer"-HW and 
> laptops got their (already included) ECC functionality disabled should 
> get hit with Googles (now 3y old) study on that topic all the day. 
> Leaving customers in danger by not offering them at least the 
> possibility to use ECC RAM is just stupid.

For the amount of RAM in devices now days then yes probably a good idea.
Adding to the problem is that there is an active market in fake brandname
DIMMs.

Alan
