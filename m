Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1BVVNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:13:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47894 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751936Ab1BVVNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:13:33 -0500
Date: Tue, 22 Feb 2011 21:15:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 2/2] staging: Use generic IGD opregion code for gma500
Message-ID: <20110222211515.36fc68d5@lxorguk.ukuu.org.uk>
In-Reply-To: <1298404994-2907-2-git-send-email-mjg@redhat.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1298404994-2907-2-git-send-email-mjg@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 15:03:14 -0500
Matthew Garrett <mjg@redhat.com> wrote:

> The gma500 driver currently includes its own IGD opregion implementation.
> Rework it to use the generic one instead. Note that this is missing a
> certain level of functionality - the driver does nothing to enable
> opregion interrupts right now, and so will simply poll for updates rather
> than doing anything sensible.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Acked-by: Alan Cox <alan@linux.intel.com>
