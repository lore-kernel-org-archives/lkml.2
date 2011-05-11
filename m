Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab1EKTL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:11:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57605 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626Ab1EKTL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:11:57 -0400
Date: Wed, 11 May 2011 20:13:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kilau, Scott" <Scott.Kilau@digi.com>
Cc: "'gregkh@suse.de'" <gregkh@suse.de>,
        "'mreed10@us.ibm.com'" <mreed10@us.ibm.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 8250_pci: Add support for the Digi/IBM PCIe 2-port
 Adapter
Message-ID: <20110511201309.607bb157@lxorguk.ukuu.org.uk>
In-Reply-To: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE28@mtk-sms-exch01.digi.com>
References: <A961E3870077E34C8FEF355D71BFDEAAC77C26CE28@mtk-sms-exch01.digi.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	},
>  	/*
> -	 * For Oxford Semiconductor and Mainpine
> +	 * For Oxford Semiconductor Tornado based devices
>  	 */

This doesn't seem to be explained in the changelog.
