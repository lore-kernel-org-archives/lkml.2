Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab0FUTE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:04:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56562 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757566Ab0FUTE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:04:27 -0400
Date: Mon, 21 Jun 2010 20:08:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Pavel Machek <pavel@ucw.cz>, Gregory Bean <gbean@codeaurora.org>,
       dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
Message-ID: <20100621200852.6f80b631@lxorguk.ukuu.org.uk>
In-Reply-To: <4C1FA141.30006@codeaurora.org>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
	<1276888375-13221-2-git-send-email-gbean@codeaurora.org>
	<20100619200249.GA2507@elf.ucw.cz>
	<4C1F9B58.6020302@codeaurora.org>
	<20100621181851.53de5f62@lxorguk.ukuu.org.uk>
	<4C1FA141.30006@codeaurora.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> licensing for headers under /include.  A dual license would work, but 
> would it also be frowned upon to use just a 3-clause BSD license like we 
> have in this patch?  Thanks.

The problem if it is only 3 clause BSD is what happens if somehow
somewhere 3 clause BSD and GPL turn out to be incompatible. The easiest
way to avoid that is to explicitly put it under both.

It's not likely to happen but its also easy to protect against
