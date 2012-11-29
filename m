Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2K2KIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:08:16 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45687 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2KIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:08:14 -0500
Date: Thu, 29 Nov 2012 10:13:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: drivres/hv
Message-ID: <20121129101317.4a7ccb8e@pyramind.ukuu.org.uk>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E5E599@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1354133850-17540-1-git-send-email-kys@microsoft.com>
	<20121128224313.GA14402@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930E5E514@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20121129000434.GA17233@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930E5E599@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All I know is that it is present and its size is known. If I have a way of knowing
> what range of mmio memory is unclaimed; I could grab that perhaps using
> the request_mem_region() call, I know the size that is reserved for this device.
> So, is there a way to query the system for the first unclaimed address in the mmio
> range.

You can add memory region resources yes. See the code in drivers/pci
which allocates mmio space to unassigned BARs and/or moves stuff around.

Alan
