Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1JDKjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:39:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47334 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755594Ab1JDKjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:39:11 -0400
Date: Tue, 4 Oct 2011 11:35:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH 1/5] spi-topcliff-pch: add tx-memory clear after
 complete transmitting
Message-ID: <20111004113559.5a8fb2f3@lxorguk.ukuu.org.uk>
In-Reply-To: <4E8ACEAE.3040400@dsn.lapis-semi.com>
References: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
	<4E8ACEAE.3040400@dsn.lapis-semi.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Oct 2011 18:15:26 +0900
Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com> wrote:

> Hi Grant,
> 
> 1 month has passed. You look very busy, right ?
> We've been long waiting for your accept.
> Could you review these patch series ?

If you've not had a response in a month for something that is a trivial
fix to a driver you maintain anyway then send it direct to Linus with a
note that Grant hasn't responded for a month. Ditto the GPIO driver.

Alan
