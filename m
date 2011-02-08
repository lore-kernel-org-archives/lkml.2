Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab1BHND2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:03:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43895 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753645Ab1BHND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:03:27 -0500
Date: Tue, 8 Feb 2011 13:07:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before
 slave_data
Message-ID: <20110208130701.19709cc6@lxorguk.ukuu.org.uk>
In-Reply-To: <20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Feb 2011 13:24:09 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> >From 8acc9371550ce5f98da56f6888ae4b898096ed2c Mon Sep 17 00:00:00 2001
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 8 Feb 2011 12:39:25 +0100
> Subject: [PATCH 05/20] pata_efar: always program master_data before slave_data
> 
> We may need to set SITRE before programming slave_data.

Do you have a documentation cite for this or is it random fiddling with a
driver you can't test ?
