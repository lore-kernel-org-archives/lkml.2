Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab1ECSfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 14:35:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39908 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754251Ab1ECSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 14:34:59 -0400
Date: Tue, 3 May 2011 19:36:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] Intel SST driver update
Message-ID: <20110503193612.22833754@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503171538.GH2893@sirena.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
	<20110503171538.GH2893@sirena.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 18:15:38 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, May 03, 2011 at 05:31:17PM +0100, Alan Cox wrote:
> > This is a forward port of various further Intel work on the SST driver in
> > staging. This keeps the staging driver up to date while the ALSA driver
> > development continues.
> 
> What's the plan for moving these out of staging?  Quite a few of these
> patches feel like moves in the wrong direction, adding more code that's
> going to have problems with mainline rather than addressing the issues
> that prevent merges.

There is a separate driver being written. In the meantime this driver is
getting updated and maintained because in the real world people have
customers and products to deliver.

It might as well therefore be maintained in tree as out. That seems to
serve Linux users rather better.

Alan
