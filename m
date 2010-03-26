Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab0CZQ7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 12:59:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55418
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626Ab0CZQ7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 12:59:06 -0400
Date: Fri, 26 Mar 2010 09:59:29 -0700 (PDT)
Message-Id: <20100326.095929.04683456.davem@davemloft.net>
To: richih.mailinglist@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP
 multi-link
From: David Miller <davem@davemloft.net>
In-Reply-To: <v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Hartmann <richih.mailinglist@gmail.com>
Date: Fri, 26 Mar 2010 17:39:27 +0100

> At least the last-level support of Telefonica and QSC was definite
> and adamant about not enabling fragmentation on _any_ PPP
> multi-link, ever.

I'm sure we can find just as many counter examples.

I doubt we'll ever be able to change the default here,
sorry.
