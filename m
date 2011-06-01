Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161935Ab1FAMsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 08:48:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43718 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758897Ab1FAMsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 08:48:53 -0400
Date: Wed, 1 Jun 2011 13:50:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andre Bartke <andre.bartke@googlemail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: Re: [PATCH] staging: intel_sst: Fix memory leak
Message-ID: <20110601135040.496ec05c@lxorguk.ukuu.org.uk>
In-Reply-To: <1306868636-23367-1-git-send-email-andre.bartke@gmail.com>
References: <1306868636-23367-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 21:03:56 +0200
Andre Bartke <andre.bartke@googlemail.com> wrote:

> In case of an error stream_bufs is not freed here.
> 
> Signed-off-by: Andre Bartke <andre.bartke@gmail.com>

Acked-by: Alan Cox <alan@linux.intel.com>
