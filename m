Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1DVQW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:22:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44165 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756107Ab1DVQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:22:55 -0400
Date: Fri, 22 Apr 2011 17:23:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <John.Linn@xilinx.com>
Cc: <michal.simek@petalogix.com>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <greg@kroah.com>,
        <grant.likely@secretlab.ca>
Subject: Re: [PATCH V2] tty/serial: add support for Xilinx PS UART
Message-ID: <20110422172352.308455ce@lxorguk.ukuu.org.uk>
In-Reply-To: <ad920746-773d-475a-9c0e-dc5dd7a4b1e1@VA3EHSMHS026.ehs.local>
References: <90e49570-bc82-41a9-ac79-2f5007e93a2a@VA3EHSMHS018.ehs.local>
	<4DB14626.8090002@petalogix.com>
	<ad920746-773d-475a-9c0e-dc5dd7a4b1e1@VA3EHSMHS026.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't have a problem removing the empty lines, but is there some
> guideline on that
> which I'm ignoring and should know?

Not in general - mostly its people inventing style. There's a lot to be
said for consistency in spacing but quite frankly people worrying about it
could spend their time more usefully on fixing actual bugs and really
ugly code of which the kernel still has a plentiful supply.

Alan
