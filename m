Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab0KZKK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 05:10:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59119 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753839Ab0KZKK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 05:10:26 -0500
Date: Fri, 26 Nov 2010 10:09:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: microcai@fedoraproject.org
Cc: linux-console@vger.kernel.org, linux-kernel@vger.kernel.org,
        brad@neruo.com
Subject: Re: [PATCH 1/2] Kernel fbcon UNICODE font support
Message-ID: <20101126100915.66112ee7@lxorguk.ukuu.org.uk>
In-Reply-To: <1290765760.6087.3.camel@cai.gentoo>
References: <1290765760.6087.3.camel@cai.gentoo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  I know there are most people speaking only English, and never meet
> non-ASCII characters on console. But, hey , what about others ?

Like the people who have never met Indic languages or half-space using
languages, or Arabic or right to left/left to right mixed or ...

>  So, here is the solution: Making framebuffer console handle UNICODE font in
> kernel.

It isn't really a solution - the rendering rules for Unicode are extremely
complex, this is why things like Pango exist to do it in user space.

Alan
