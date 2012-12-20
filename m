Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2LTNOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:14:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55198 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab2LTNOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:14:23 -0500
Date: Thu, 20 Dec 2012 13:20:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Christian Bahls - gmx.de" <christian.bahls@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Encrypted block devices and suspend to ram
Message-ID: <20121220132059.3cc85cfd@pyramind.ukuu.org.uk>
In-Reply-To: <CAALC5YGq=DL1LWCb6QjqkACJLo6Z8SgwjNYoMXtvFF7a9KGhDg@mail.gmail.com>
References: <CAALC5YGq=DL1LWCb6QjqkACJLo6Z8SgwjNYoMXtvFF7a9KGhDg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This would thwart all sorts of social and physical attacks on the device.
> 
> Has something like this ever been attempted?

man cryptsetup

Alan
