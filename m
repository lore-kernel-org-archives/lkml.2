Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1CQXzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:55:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41155 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755723Ab1CQXzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:55:14 -0400
Date: Thu, 17 Mar 2011 23:55:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergey Lapin <slapin@ossfans.org>
Cc: <linux-x25@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Allow LAPB users know which data were actually sent.
Message-ID: <20110317235532.44c0e202@lxorguk.ukuu.org.uk>
In-Reply-To: <1300400422-8820-1-git-send-email-slapin@ossfans.org>
References: <1300400422-8820-1-git-send-email-slapin@ossfans.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 18:20:22 -0400
Sergey Lapin <slapin@ossfans.org> wrote:

> Normally, when LAPB is transport layer for X.25 protocol,
> internal mechanics of X.25 knows wheather data were actually
> received by peer. But for non-X.25 protocols which use LAPB
> as data reliability layer, it is important to have some way
> to know what was actually sent, so we add transmit indication.

Looks sensible but your patch doesn't add a user for it so what is it
needed for ?
