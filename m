Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab0I2JgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:36:21 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41461 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750936Ab0I2JgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:36:20 -0400
Date: Wed, 29 Sep 2010 11:00:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: gregkh@suse.de, feng.tang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mrst_max3110: Missing linux/irq.h include.
Message-ID: <20100929110025.3d5d9efa@lxorguk.ukuu.org.uk>
In-Reply-To: <20100928.213620.193710221.davem@davemloft.net>
References: <20100928.213620.193710221.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 21:36:20 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> 
> This driver makes use of IRQ_TYPE_EDGE_FALLING, therefore it must
> include linux/irq.h
> 
> drivers/serial/mrst_max3110.c: In function 'serial_m3110_startup':
> drivers/serial/mrst_max3110.c:470:5: error: 'IRQ_TYPE_EDGE_FALLING' undeclared (first use in this function)
> drivers/serial/mrst_max3110.c:470:5: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Alan Cox <alan@linux.intel.com>
