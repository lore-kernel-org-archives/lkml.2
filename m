Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1ECRAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:00:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54928 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753923Ab1ECRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:00:49 -0400
Date: Tue, 3 May 2011 18:02:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/23] intel_sst: MSIC codec power optimisation
Message-ID: <20110503180202.0900afaa@lxorguk.ukuu.org.uk>
In-Reply-To: <20110503165838.GF2893@sirena.org.uk>
References: <20110503162919.24853.58699.stgit@bob.linux.org.uk>
	<20110503163200.24853.6842.stgit@bob.linux.org.uk>
	<20110503165838.GF2893@sirena.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011 17:58:38 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, May 03, 2011 at 05:32:01PM +0100, Alan Cox wrote:
> 
> > From: Vinod Koul <vinod.koul@intel.com>
> > 
> > This patch adds power optimization for the msic codec and ensure
> > codec is completely powered off when codec is idle.
> 
> Once you move over to proper CODEC drivers the core will take care of
> this stuff for you.

Please see 00/23

"This is a forward port of various further Intel work on the SST driver in
staging. This keeps the staging driver up to date while the ALSA driver
development continues."


Alan
