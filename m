Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934280Ab0KPLHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:07:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32946 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933043Ab0KPLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:07:17 -0500
Date: Tue, 16 Nov 2010 11:05:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Jiri Slaby" <jslaby@suse.cz>, "Baruch Siach" <baruch@tkos.co.il>,
        linux-kernel@vger.kernel.org,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Greg KH" <greg@kroah.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Alex Gershgorin" <agersh@rambler.ru>
Subject: Re: [PATCHv3] drivers/misc: Altera active serial implementation
Message-ID: <20101116110535.404736f9@lxorguk.ukuu.org.uk>
In-Reply-To: <c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
References: <fa8a1cda966a356d4c0bfe6e285c01679bf6ef60.1289809182.git.baruch@tkos.co.il>
	<4CE0FE71.6000303@suse.cz>
	<20101115100838.GA3649@jasper.tkos.co.il>
	<4CE10B32.8090705@suse.cz>
	<c30e46c1b5343789b6475722071c3020.squirrel@webmail.greenhost.nl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or to be more clear

NAK use of misc_register etc.

I don't care if it ends up in drivers/misc as a directory but it should
allocate its own dynamic device major.

