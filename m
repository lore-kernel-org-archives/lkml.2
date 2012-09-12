Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab2ILN1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:27:41 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:59498 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab2ILN1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:27:39 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkqJAFeNUFBV5qoUPGdsb2JhbABFhR4jhQCvfAICfhkBAQEBHhkNJ4IgAQEEATocIwULCAMOOBQlChqIGgq8cxSLL4E3g3hgA5VehW+NGQ
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="407956073"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 12 Sep 2012 15:34:28 +0200
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Input: cyttsp4 - bus driver for Cypress TMA4XX
 touchscreen devices
Message-ID: <20120912133428.GA4894@polaris.bitmath.org>
References: <fery@cypress.com>
 <1344344978-30453-1-git-send-email-fery@cypress.com>
 <50377C60.4020008@cypress.com>
 <20120824173408.GA6176@polaris.bitmath.org>
 <503B099A.6010807@cypress.com>
 <50508B45.40706@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50508B45.40706@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ferruh,

> Before finalizing the work, we want to learn if introducing new files
> for new driver is acceptable and our effort is inline with your request,
> can you please comment on it?

New files are certainly alright when they are warranted, but of course
it depends on the details. We will know once you have submitted the
new version. :-)

Thanks,
Henrik
