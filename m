Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2JIJ33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 05:29:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44495 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab2JIJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 05:29:27 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Maxin B John <maxin.john@gmail.com>
Cc: "Ben Dooks \(embedded platforms\)" <ben-linux@fluff.org>,
        "Wolfram Sang \(embedded platforms\)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare \(PC drivers\, core\)" <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] i2c: busses: i2c-ocores: switch to devm_request_and_ioremap
References: <20120923133358.GA22861@linux-3ix0.site>
	<874nmoa9b1.fsf@macbook.be.48ers.dk>
	<CAMhs6YztTFh0fQFfJOwc++fr-xXxEJU5KvcSvOcAcyyDgWOBDQ@mail.gmail.com>
Date: Tue, 09 Oct 2012 11:29:22 +0200
In-Reply-To: <CAMhs6YztTFh0fQFfJOwc++fr-xXxEJU5KvcSvOcAcyyDgWOBDQ@mail.gmail.com>
	(Maxin B. John's message of "Tue, 9 Oct 2012 05:13:13 -0400")
Message-ID: <87y5jgc7t9.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Maxin" == Maxin B John <maxin.john@gmail.com> writes:

 Maxin> Hi Peter,

 Maxin> This drops a few lines of code and allows common APIs to handle
 Maxin> those for us.

 Maxin> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

 >> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

 Maxin> Is there any update on this ?

I'm expecting Wolfram to pick it up.

-- 
Bye, Peter Korsgaard
