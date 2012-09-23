Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab2IWSW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 14:22:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38187 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2IWSWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 14:22:30 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Wolfram Sang \(embedded platforms\)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] i2c: busses: i2c-ocores: switch to devm_request_and_ioremap
References: <20120923133358.GA22861@linux-3ix0.site>
Date: Sun, 23 Sep 2012 20:22:26 +0200
In-Reply-To: <20120923133358.GA22861@linux-3ix0.site> (Maxin B. John's message
	of "Sun, 23 Sep 2012 09:33:58 -0400")
Message-ID: <874nmoa9b1.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Maxin" == Maxin B John <maxin.john@gmail.com> writes:

 Maxin> This drops a few lines of code and allows common APIs to handle
 Maxin> those for us.

 Maxin> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
