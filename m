Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1HJPIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:08:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752915Ab1HJPIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:08:48 -0400
Date: Wed, 10 Aug 2011 16:11:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Fix compiler warning
Message-ID: <20110810161159.18ba38bb@lxorguk.ukuu.org.uk>
In-Reply-To: <225E012C-3134-4F86-A130-B205145D3E18@kernel.crashing.org>
References: <1312445581-16283-1-git-send-email-galak@kernel.crashing.org>
	<20110804194520.5a3dbd38@pyx>
	<225E012C-3134-4F86-A130-B205145D3E18@kernel.crashing.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Use a newer gcc - modern gcc gets it right.
> 
> How modern? Building with a gcc 4.5.x

4.5.x gets this right on x86 and I don't want to risk hiding a future bug
in that area of code with some mindless initialiser hacks.

(OTOH if you can figure a way to restructure that code a bit so its tidy,
clear and the compiler gets it right too ...)

Alan
