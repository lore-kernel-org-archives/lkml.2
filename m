Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2CERgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:36:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43168 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab2CERgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:36:32 -0500
Date: Mon, 5 Mar 2012 17:38:06 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20120305173806.15c73097@pyramind.ukuu.org.uk>
In-Reply-To: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Mar 2012 08:47:41 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> Allow drivers to report at probe time that they cannot get all the resources
> required by the device, and should be retried at a later time.

Stick my oar in for that as well. We've got several bits of Intel SCU
using code that right now have ugly hacks in them (and generally aren't
upstream) because they must cope with random ordering problems.

Alan
