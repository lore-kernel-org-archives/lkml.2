Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2CCQNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 11:13:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42973 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2CCQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 11:13:40 -0500
Date: Sat, 3 Mar 2012 16:15:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] compat: makes all compat symbols EXPORT_SYMBOL_GPL()
Message-ID: <20120303161537.0b4ac739@pyramind.ukuu.org.uk>
In-Reply-To: <4F52141C.2050808@broadcom.com>
References: <1330729706-11113-1-git-send-email-mcgrof@frijolero.org>
	<4F52141C.2050808@broadcom.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some of the modules in this patch are dual-licensed. I was under the 
> impression that EXPORT_SYMBOL_GPL was specifically for GPL-only code 
> although I could not find any specifics in the Documentation folder. Do 
> you (or someone else) have a reference on this topic?

If your code is licensed GPL or greater rights then you shouldn't have a
problem. The module loader recognizes

	"GPL"
	"GPL v2"
	"GPL and additional rights"
	"Dual BSD/GPL"
	"Dual MIT/GPL"
	"DUal MPL/GPL"

as legitimate users of _GPL. Any work which is derivative of the kernel
(which in practise I suspect means almost any module) will need a GPL
compatible licence anyway.

