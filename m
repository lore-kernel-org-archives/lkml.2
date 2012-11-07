Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2KGO7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 09:59:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42885 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2KGO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 09:59:31 -0500
Date: Wed, 7 Nov 2012 15:04:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] isdn: Make CONFIG_ISDN depend on CONFIG_NETDEVICES
Message-ID: <20121107150436.3d25ee51@pyramind.ukuu.org.uk>
In-Reply-To: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
References: <1352282103-13665-1-git-send-email-lee.jones@linaro.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Nov 2012 10:55:03 +0100
Lee Jones <lee.jones@linaro.org> wrote:

> It doesn't make much sense to enable ISDN services if you don't
> intend to connect to a network. 

I would disagree. However what I don't understand and you've not
explained is why the current code is a bug or a problem ?

This seems to be a make-work inconvenience causing patch that serves no
useful purpose ?

Alan
