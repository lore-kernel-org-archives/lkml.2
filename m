Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2KIUVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:21:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46254 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab2KIUV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:21:28 -0500
Date: Fri, 9 Nov 2012 20:26:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andy Grover <agrover@redhat.com>
Cc: nab@risingtidesystems.com, Chris Friesen <chris.friesen@genband.com>,
        Jon Mason <jdmason@kudzu.us>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marc Fleischmann <mwf@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
Message-ID: <20121109202632.26b39674@pyramind.ukuu.org.uk>
In-Reply-To: <509D5EF3.9030809@redhat.com>
References: <509A915B.30105@redhat.com>
	<CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	<509B117A.6070708@genband.com>
	<509BE460.6010404@redhat.com>
	<1352405111.29589.476.camel@haakon2.linux-iscsi.org>
	<509C22B2.8010600@redhat.com>
	<1352426896.29589.512.camel@haakon2.linux-iscsi.org>
	<20121109110336.41833034@pyramind.ukuu.org.uk>
	<509D5EF3.9030809@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Nov 2012 11:52:19 -0800
Andy Grover <agrover@redhat.com> wrote:

> On 11/09/2012 03:03 AM, Alan Cox wrote:
> > I fail to understand the maintainer question however. If you were trying
> > to block people adding target features that competed that would be a
> > different thing.
> 
> You think it's ok for us to have an unrepentant GPL violator as a
> subsystem maintainer??
> 
> If that's really what you're saying then I think that's crazy.

If he was a GPL violator and had been shown so it would be.

However it's alleged GPL violator, and we could have the same argument
about say Nvidia or half a dozen other contributors and companies before
we get to things like the GPLv2 versus DRM question (all the necessary
scripts including the key).

But RH could always sue him, or simply provide an open alternative I
guess (or indeed let secure boot and the RHEL plans for it put him out of
business) ;)

Alan
