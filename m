Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030703Ab2CSP6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:58:13 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50182 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684Ab2CSP6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:58:12 -0400
Date: Mon, 19 Mar 2012 15:56:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Shea Levy <shea@shealevy.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: EFI Boot Stub Early Console
Message-ID: <20120319155639.7cff5df6@pyx>
In-Reply-To: <1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>
References: <4F5E46EA.7020602@shealevy.com>
	<4F5E47E4.2070303@shealevy.com>
	<4F5E74A0.60001@zytor.com>
	<4F5E761B.7010608@shealevy.com>
	<4F5E775D.7080702@zytor.com>
	<4F648DD3.3000405@shealevy.com>
	<1332069701.4041.42.camel@mfleming-mobl1.ger.corp.intel.com>
	<4F65D09B.4050807@shealevy.com>
	<1332146834.4041.46.camel@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > any bootloader (including the bootstub) will call ExitBootServices() 
> > before any printk'ing actually happens?? Or am I misunderstanding the 
> > spec somehow? I suppose I could just try it and see what happens...
> 
> Oops. Good point, that isn't going to work.

Surely it works fine if you are using bootstub directly from EFI ?
