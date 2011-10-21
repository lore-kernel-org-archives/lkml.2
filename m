Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1JUNgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 09:36:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60377 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab1JUNgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 09:36:23 -0400
Date: Fri, 21 Oct 2011 14:36:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: ext Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sre@debian.org>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, govindraj.ti@gmail.com,
        pawel.szyszuk@stericsson.com, sjur.brandeland@stericsson.com,
        peter_henn@gmx.de
Subject: Re: [RFC PATCHv5 0/7] HSI framework and drivers
Message-ID: <20111021143617.7b37032c@lxorguk.ukuu.org.uk>
In-Reply-To: <1319192913.2702.38.camel@groo>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
	<20111020125705.GA2121@earth.universe>
	<CACRpkdYBFGp4+oFUZvXn-wpUk0fmLiKixchQKcFo9XTDW=51+g@mail.gmail.com>
	<1319192913.2702.38.camel@groo>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A. I create the branch with just the hsi_char and the hsi framework
> B. The same as A but with STE or another hsi/ssi controller driver.

With my Intel hat on we've also got stuff using this framework and
controllers that we'd want to sync with the current version of the core
code (I think it's diverged a bit).

Alan
