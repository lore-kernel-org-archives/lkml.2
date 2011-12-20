Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab1LTK4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 05:56:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45685 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab1LTK4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 05:56:10 -0500
Date: Tue, 20 Dec 2011 10:56:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Vinod Koul <vkoul@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>, vinod.koul@intel.com,
        Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH 3/3] dmaengine: intel_mid_dma: remove legacy pm
 interface
Message-ID: <20111220105647.45cd4218@pyramind.ukuu.org.uk>
In-Reply-To: <1324372396.1641.10064.camel@vkoul-udesk3>
References: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
	<1324026100-3124-4-git-send-email-adrian.hunter@intel.com>
	<1324372396.1641.10064.camel@vkoul-udesk3>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011 14:43:16 +0530
Vinod Koul <vkoul@infradead.org> wrote:

> On Fri, 2011-12-16 at 11:01 +0200, Adrian Hunter wrote:
> > From: Kristen Carlson Accardi <kristen@linux.intel.com>
> > 
> > Drivers should not support both legacy pm and new framework.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> There seems to be a similar patch from Kristen sent by Alan??

Same patch via two paths.

Alan
