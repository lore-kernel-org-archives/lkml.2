Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1CQTYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:24:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60621 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751566Ab1CQTYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:24:39 -0400
Date: Thu, 17 Mar 2011 19:24:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-serial@vger.kernel.org,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 1/2] serial: 8250: Add a notifier chain for driver
 registration.
Message-ID: <20110317192441.69c699b1@lxorguk.ukuu.org.uk>
In-Reply-To: <20110317184723.GQ9597@angua.secretlab.ca>
References: <1300325167-26433-1-git-send-email-ddaney@caviumnetworks.com>
	<1300325167-26433-2-git-send-email-ddaney@caviumnetworks.com>
	<20110317121849.49d7c425@lxorguk.ukuu.org.uk>
	<20110317182510.GN9597@angua.secretlab.ca>
	<4D82560B.4090800@caviumnetworks.com>
	<20110317184723.GQ9597@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If we did that, serial8250_probe() would automatically do the right thing.
> 
> Take a look at the way arch/powerpc/platforms/512x/pdm360ng.c uses a
> notifier for amending a platform_device with additional data..

I tend to view arch specific embedded code as rather like very dubious
parties. What goes on in other peoples' house out of sight is none of my
business.

The 8250 however is core code so it should keep its clothers on and behave
in a manner befitting its status.

What part of the problem can't be solved by doing it properly using the
device registration interfaces we have today ?

Alan
