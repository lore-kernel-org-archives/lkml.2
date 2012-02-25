Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2BYIqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 03:46:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:52342 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2BYIqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 03:46:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2] USB: Support for LPC32xx SoC
Date: Sat, 25 Feb 2012 08:45:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Roland Stigge <stigge@antcom.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, Alan Stern <stern@rowland.harvard.edu>
References: <1330030639-3796-1-git-send-email-stigge@antcom.de> <201202241503.27406.arnd@arndb.de> <20120225035128.GA4455@pengutronix.de>
In-Reply-To: <20120225035128.GA4455@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201202250845.44427.arnd@arndb.de>
X-Provags-ID: V02:K0:I4AZM9KNkvtxuSUDnIBzyChkK9RvdGVJb8isZn9596a
 8mvHg1KNEbuuhvEeAr8oPdVnrbPjrKSUdGsSujIdP7CD/YpQH+
 XAXEt7CxSZOlQCBIdqZ2Jumt2775hSl2QsICEKlL0eKrXb5FN1
 IfQls+awppNEPzDiJ+v+jlUdDq8X6oZg9la5wzvyCBEZolhiHf
 kLcHCd0Y3xK/GtM5mme8XcJtg0+wUOAgUmtG1cxJEpwY4jrR+G
 k4dTZXU+eqpVuhKaWXxs7h6zubhRwFqcVdSYEAomudAw9ZdriT
 hpqkJQQnRoEM4Y9K2PEIXmuNloTcSN904FiQom+ryzrNWLBQkW
 31a7fssFm1u1H7hebGmE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 February 2012, Wolfram Sang wrote:
> > Unfortunately, the way that ohci handles the abstraction between the
> > various implementations is backwards, it would be much easier if the
> > main driver was following that model to start with.
> 
> ... exactly for that reason I didn't suggest it. Looking at other ohci-sources
> (e.g. ohci-omap.c), machine_is_* seems to be the consistent use-case.

I still hope that someone takes the time to convert ohci and ehci into
something more regular, building the .c files separately instead of the
conditional #include "foo.c" inside of the main file.

Alan and Greg, do you know if anyone is working on that, and if not do you
think someone should do it?

	Arnd
