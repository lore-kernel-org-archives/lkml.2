Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0CZREL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:04:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60209
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab0CZREF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:04:05 -0400
Date: Fri, 26 Mar 2010 10:04:29 -0700 (PDT)
Message-Id: <20100326.100429.260013324.davem@davemloft.net>
To: richih.mailinglist@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP
 multi-link
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100326.095929.04683456.davem@davemloft.net>
References: <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
	<20100326.095929.04683456.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


BTW, it seems your email client very thoroughly corrupted your
original patch submission.

This is a common problem with gmail, please read:

	linux/Documentation/email-clients.txt

so that you can learn how to adjust your email client settings such
that your outgoing patches are usable by us.

Thanks.
