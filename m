Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab1CRLeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 07:34:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55841 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755291Ab1CRLeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 07:34:16 -0400
Date: Fri, 18 Mar 2011 11:34:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Lapin <slapin@ossfans.org>
Cc: linux-x25@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow LAPB users know which data were actually sent.
Message-ID: <20110318113433.39794ca5@lxorguk.ukuu.org.uk>
In-Reply-To: <20110318005220.GA9674@build.ihdev.net>
References: <1300400422-8820-1-git-send-email-slapin@ossfans.org>
	<20110317235532.44c0e202@lxorguk.ukuu.org.uk>
	<20110318005220.GA9674@build.ihdev.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Looks sensible but your patch doesn't add a user for it so what is it
> > needed for ?
> 
> I implement accessor for special equipment (acessing fiscal information)
> which uses custom protocol over LAPB. As it is being implemented,
> I actually wanted to know if this approach for using LAPB is good enough
> for mainline submission, as I want to have kernel part to be in mainline.
> I think I will have the rest of patches ready within two weeks.

It seems sensible as an implementation to me so I would carry on using
that model and then submit it with all the other bits when you are ready.
