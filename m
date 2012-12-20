Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2LTNFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:05:45 -0500
Received: from mout.gmx.net ([212.227.17.20]:64317 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab2LTNFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:05:40 -0500
X-Authenticated: #20566476
X-Provags-ID: V01U2FsdGVkX18mE4AjY8smnw8/TXXt2OUVyxqJlA1/mW8nd0sxU2
	8z2jqnctHXaVT/
MIME-Version: 1.0
From: "Christian Bahls - gmx.de" <christian.bahls@gmx.de>
Date: Thu, 20 Dec 2012 14:00:04 +0100
Message-ID: <CAALC5YGq=DL1LWCb6QjqkACJLo6Z8SgwjNYoMXtvFF7a9KGhDg@mail.gmail.com>
Subject: Encrypted block devices and suspend to ram
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

please excuse if it looks like blind ignorance on my part
should this topic already have been brought and up
and being missed by my shallow web search.

I would have a feature request for encrypted block devices
(using LUKS especially)

I would be really grateful if the kernel had an option to scrub
all key related material before suspending to ram
and reinitialize the encrypted block device on wake up.

This would thwart all sorts of social and physical attacks on the device.

Has something like this ever been attempted?

Kind regards
 Christian Bahls
