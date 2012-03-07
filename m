Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab2CGP7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:59:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32903 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2CGP7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:59:30 -0500
Date: Wed, 7 Mar 2012 16:01:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: torvalds@linux-foundation, airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm, gma500: Fix Cedarview boot failures in 3.3-rc
Message-ID: <20120307160131.6ab5ab52@pyramind.ukuu.org.uk>
In-Reply-To: <4F577BC8.8050409@canonical.com>
References: <20120302233037.027fcc66@pyramind.ukuu.org.uk>
	<4F577BC8.8050409@canonical.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see stable@vger.kernel.org in the Cc list.  Will this patch be 
> submitted to stable?

No. Cedartrail support is not enabled in earlier kernels anyway.

Alan
