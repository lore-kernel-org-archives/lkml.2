Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1HFKPA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 06:15:00 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38121 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab1HFKO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 06:14:58 -0400
Date: Sat, 6 Aug 2011 11:14:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2o: use kstrdup()
Message-ID: <20110806111430.5ae2ca0d@pyx>
In-Reply-To: <1312623053.5589.67.camel@localhost.localdomain>
References: <1312623053.5589.67.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Aug 2011 11:30:50 +0200
Thomas Meyer <thomas@m3y3r.de> wrote:

> From: Thomas Meyer <thomas@m3y3r.de>
> 
>  Use kstrdup rather than duplicating its implementation
> 
>  The semantic patch that makes this output is available
>  in scripts/coccinelle/api/kstrdup.cocci.
> 
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Acked-by: Alan Cox <alan@linux.intel.com>
