Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342Ab1KJNFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:05:30 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59708 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171Ab1KJNF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:05:29 -0500
Date: Thu, 10 Nov 2011 13:06:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: problems with pata_via, hangs after random time
Message-ID: <20111110130631.482fac9a@lxorguk.ukuu.org.uk>
In-Reply-To: <20111110124742.GA3246@vip.manty.net>
References: <20111110124742.GA3246@vip.manty.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm thinking of this problems as via_pata based because of my changes on the
> config, but I really don't know if this is the case or if the hardware is
> starting to fail, so maybe the best thing to do for now is to go back to the
> old IDE drivers and seek high uptimes there and if everything is ok then go
> back to try to debug this, as we don't have much info right now.

I think it would be useful to see if it runs solidly with the exact same
configuration but the old IDE driver. The error dump you have is bizarre
to say the least so it'd hard to guess what is going on.

If it is reliable with the other drive then we can start doing close
comparisons of register settings and the like

Alan
