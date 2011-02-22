Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1BVRlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:41:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49669 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754545Ab1BVRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:41:17 -0500
Date: Tue, 22 Feb 2011 17:43:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@linux.intel.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Message-ID: <20110222174308.2469721a@lxorguk.ukuu.org.uk>
In-Reply-To: <201102221809.50716.arnd@arndb.de>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
	<201102221809.50716.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before I start looking at the code, one high-level question: How much of
> the code in the gma500 driver would be shared with SOCs from other people
> (ARM based, typically) that use the PowerVR SGX core?

My understanding is none.

> IOW, is this driver only for parts that Intel (or whoever) has put around
> the licensed 3D core, or is it actually the same code that the others would
> use for a non-3D SGX driver?

The mode setting is all Intel - hence the similarity to i9xx

Alan
