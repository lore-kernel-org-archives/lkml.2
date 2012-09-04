Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab2IDV4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:56:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43772 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757646Ab2IDV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:56:32 -0400
Date: Tue, 4 Sep 2012 23:01:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, arve@android.com, kernel-team@android.com,
        john.stultz@linaro.org
Subject: Re: [PATCH v2] drivers/tty: Folding Android's keyreset driver in
 sysRQ
Message-ID: <20120904230117.5a44eb89@pyramind.ukuu.org.uk>
In-Reply-To: <5046783D.4020702@linaro.org>
References: <1346365854-28441-1-git-send-email-mathieu.poirier@linaro.org>
	<20120830230129.GC21501@core.coreip.homeip.net>
	<50413200.5010104@linaro.org>
	<20120831230227.6e5008b5@pyramind.ukuu.org.uk>
	<20120831224128.GA22073@core.coreip.homeip.net>
	<50414140.60102@linaro.org>
	<20120831232234.GB22142@core.coreip.homeip.net>
	<5046783D.4020702@linaro.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> which brings us to the "reset_fn()" function - in my opinion it offers
> significant advantages and should be kept in the design.  What I'm not
> so clear about is on the implementation.  Should it be kept as part of a
> platform data or be implemented as a notifier as suggested by Alan.  I
> am looking for guidance here and suggestions are encouraged.

Not sure reset_fn is the best name but it'll do for me. As for things like
notifiers, thats extra complexity. *When* someone needs it then they can
add it. We don't need to add extra complexity now.

