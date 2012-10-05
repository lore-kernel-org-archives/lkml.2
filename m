Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2JESsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:48:14 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57022 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab2JESsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:48:08 -0400
Date: Fri, 5 Oct 2012 19:53:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: mathieu.poirier@linaro.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, arve@android.com,
        kernel-team@android.com, john.stultz@linaro.org
Subject: Re: [PATCH] drivers/tty: Folding Android's keyreset driver in sysRQ
Message-ID: <20121005195303.6e652997@pyramind.ukuu.org.uk>
In-Reply-To: <20121005181608.GA24356@core.coreip.homeip.net>
References: <1349459969-17473-1-git-send-email-mathieu.poirier@linaro.org>
	<20121005181608.GA24356@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have the same objection as before: using platform device solely for
> the purpose of passing some data from board code to the driver. Surely
> there are other ways of passing this bit of data... What about, for
> example, making it an empty weak symbol so that board code could
> override it with strong one?

I have the same objection to it being passed in other weird ways. This is
cross architecture, cross device stuff. Magic architecture goo and weak
symbols are not the right solution.

The reset switch is a device, physically and logically.

Alan
