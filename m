Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab1HKMjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:39:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40186 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755306Ab1HKMjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:39:46 -0400
Date: Thu, 11 Aug 2011 13:43:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gma500: Add VBLANK support for Poulsbo hardware
Message-ID: <20110811134309.3acbd6d1@lxorguk.ukuu.org.uk>
In-Reply-To: <1312234930-2387-3-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1312234930-2387-1-git-send-email-patrik.r.jakobsson@gmail.com>
	<1312234930-2387-3-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  1 Aug 2011 23:42:10 +0200
Patrik Jakobsson <patrik.r.jakobsson@gmail.com> wrote:

> Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
> ---
>  drivers/staging/gma500/psb_drv.h |    3 ++
>  drivers/staging/gma500/psb_irq.c |   71 ++++++++++++++++++++++----------------
>  2 files changed, 44 insertions(+), 30 deletions(-)

All three applied

Thanks

Alan
