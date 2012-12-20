Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab2LTNDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:03:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55181 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2LTNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:03:16 -0500
Date: Thu, 20 Dec 2012 13:08:43 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Xiao Jin <jin.xiao@intel.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com, sboyd@codeaurora.org,
        vincentx.pillet@intel.com
Subject: Re: [PATCH] n_gsm.c: add tx_lock in gsm_send
Message-ID: <20121220130843.51726836@pyramind.ukuu.org.uk>
In-Reply-To: <1355894170.9600.94.camel@xiaojin>
References: <1355894170.9600.94.camel@xiaojin>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2012 13:16:10 +0800
Xiao Jin <jin.xiao@intel.com> wrote:

> From: xiaojin <jin.xiao@intel.com>
> Date: Wed, 19 Dec 2012 11:53:43 +0800
> Subject: [PATCH] n_gsm.c: add tx_lock in gsm_send
> 
> All the call to gsm->output should be in the tx_lock,
> that could avoid potential race from MUX level. But
> we have no tx_lock in gsm_send.
> 
> This patch is to add tx_lock in gsm_send.
> 
> Signed-off-by: xiaojin <jin.xiao@intel.com>

Acked-by: Alan Cox <alan@linux.intel.com>
