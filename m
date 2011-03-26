Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1CZPyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 11:54:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53621 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751888Ab1CZPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 11:54:10 -0400
Date: Sat, 26 Mar 2011 15:54:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: igor@novg.net
Cc: <jgarzik@pobox.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.38.1] pata_it821x: Add module param to force UDMA on
 Vortex86SX
Message-ID: <20110326155433.323b6f6a@lxorguk.ukuu.org.uk>
In-Reply-To: <90c1a5f93e6d67aec9f67a1d4c0deb86@novg.net>
References: <89bf4e2c74a16f130208a485c6eafd77@novg.net>
	<20110326125441.3e628850@lxorguk.ukuu.org.uk>
	<90c1a5f93e6d67aec9f67a1d4c0deb86@novg.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Although if you want to take it up with DMP and find out if they have
> > updated rules or checks that want pushing that might be useful.
> 
>  No, i do not intend to contact them, i just wanted people to have an 
>  on/off
>  switch in kernel, not to push this patch by all means necessary.

If you want a patch in the upstream kernel then you need to do the
related work. If you can't even be bothered to follow up why an erratum
was added by the manufacturer then you've comprehensively missed the
standards we work to.

>  If this option is considered by community unneeded, i'll just have to 
>  patch my
>  own kernel with every upgrade :)

By all means. The GPL ensures you can do this and it means you won't
leave us with a one off potentially unsafe and unmaintained update.

Alan
