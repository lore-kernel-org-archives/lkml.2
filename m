Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1GOXFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 19:05:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52100 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752657Ab1GOXFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 19:05:43 -0400
Date: Sat, 16 Jul 2011 00:07:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Witten <mfwitten@gmail.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: Re: Large Patch Series in Email         (was Re: [PATCH 0000/0117]
 Staging: hv: Driver cleanup)
Message-ID: <20110716000739.3239bac8@lxorguk.ukuu.org.uk>
In-Reply-To: <84fa825a57d34571a5aa66ae7299461c-mfwitten@gmail.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
	<84fa825a57d34571a5aa66ae7299461c-mfwitten@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Do not send more than 15 patches at once to the vger
>   mailing lists!!!
> 
> and, accordingly, I went to the trouble of setting up a GitHub
> account to host a repo from which I could issue *one* single
> PULL request email; I get a little miffed every time my
> inbox gets blasted with hundreds of patches when others don't
> do similarly.

The problem with dumping stuff that needs review into a git tree is it's
a lot of hassle to review so the advice is kind of outdated in such cases.
It's good advice for things like big new subsystems perhaps but not for
review.

As is always the case social norms evolve faster than the people who feel
compelled to attempt to document them.

There are lots of web archives of the list and it's also not hard to set
up mail tools to shuffle long emails into a folder so there are plenty of
ways to manage and read the lists without being part of it.

And someone should probably updating the CodingStyle document to reflect
reality 8)

Alan
