Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1GMNSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:18:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53369 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753322Ab1GMNSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:18:16 -0400
Date: Wed, 13 Jul 2011 14:20:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Samuli Konttila <samuli.konttila@aavamobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: cy8ctmg110_ts - set reset_pin and irq_pin from
 platform data
Message-ID: <20110713142055.3036c62d@lxorguk.ukuu.org.uk>
In-Reply-To: <1310562419.5753.2.camel@phoenix>
References: <1310562419.5753.2.camel@phoenix>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 21:06:59 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> The implementation in cy8ctmg110_probe() does not properly set reset_pin
> and irq_pin from platform data. Let's fix it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Current implementation returns -ENODEV if no pdata available.
> But it does not use the information from pdata.
> I think currently the driver does not work because both ts->reset_pin and ts->irq_pin are 0, then gpio_request with ts->irq_pin will fail.
> 
> Just found this bug while reading the code.
> I don't have this hardware. I appreciate if someone can test it.

Looks right, but I'm likewise unable to test it as I no longer have
access to a device using it.

Alan
