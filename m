Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab0FXJL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:11:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54068 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754340Ab0FXJL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:11:27 -0400
Date: Thu, 24 Jun 2010 10:16:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henri =?ISO-8859-14?B?SORra2luZW4=?= <henuxd@gmail.com>
Cc: gregkh@suse.de, ossama.othman@intel.com, alan@linux.intel.com,
       mattij.lammi@gmail.com, randy.dunlap@oracle.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: memrar: Moved memrar_allocator struct to
 memrar_allocator.c
Message-ID: <20100624101618.51dea6d5@lxorguk.ukuu.org.uk>
In-Reply-To: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
References: <1277363386-4817-1-git-send-email-henuxd@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +size_t memrar_allocator_largest_free_area(struct memrar_allocator *allocator)
> +{
> +	if (allocator == NULL)
> +		return 0;
> +	return allocator->largest_free_area;
> +}

static ?
