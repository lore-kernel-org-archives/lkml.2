Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab1FAVni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:43:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39140 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760027Ab1FAVng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:43:36 -0400
Date: Wed, 1 Jun 2011 22:45:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Scott Wood <scottwood@freescale.com>
Cc: Timur Tabi <timur@freescale.com>, <kumar.gala@freescale.com>,
        <linux-kernel@vger.kernel.org>, <akpm@kernel.org>,
        <linux-console@vger.kernel.org>, <greg@kroah.com>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor
 management driver
Message-ID: <20110601224506.4c593d61@lxorguk.ukuu.org.uk>
In-Reply-To: <20110601155430.4d5aa6de@schlenkerla.am.freescale.net>
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
	<20110601204618.32190be9@lxorguk.ukuu.org.uk>
	<20110601155430.4d5aa6de@schlenkerla.am.freescale.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> There's a check for -ENOIOCTLCMD in vfs_ioctl() -- though it generates
> -EINVAL rather than -ENOTTY (why?).

Good question - perhaps someone didn't read the spec 8)
