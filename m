Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab1B0Mdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 07:33:50 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:42639 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab1B0Mdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 07:33:47 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 27 Feb 2011 13:34:05 +0100
To: Kevin McNeely <Kevin.McNeely@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Brown <davidb@codeaurora.org>,
        Trilok Soni <tsoni@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Eric Miao <eric.y.miao@gmail.com>, Mike Frysinger <vapier@gentoo.org>,
        Alan Cox <alan@linux.intel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v4 1/3] 1/3 Touchscreen: Cypress TTSP G3 Core Driver
Message-ID: <20110227123405.GA4961@polaris.bitmath.org>
References: <kev@cypress.com>
 <1294188847-24728-1-git-send-email-kev@cypress.com>
 <20110105085942.GA23321@polaris.bitmath.org>
 <FB9C2CB29A07AB45B575A4E8D2AABC09014003B8@labamba.mis.cypress.com>
 <20110105173403.GA2146@polaris.bitmath.org>
 <FB9C2CB29A07AB45B575A4E8D2AABC0901629825@labamba.mis.cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB9C2CB29A07AB45B575A4E8D2AABC0901629825@labamba.mis.cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.248.192.164
X-Scan-Result: No virus found in message 1Ptfnd-0002R9-4Y.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1Ptfnd-0002R9-4Y 8cac0bc5706674e7fd6fa72c0c34aaeb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> I have been testing with Android based systems.
> What system configurations are good for testing the slot handling in
> Protocol B?

The mtview project is a graphical way to test out hardware [1]. If no
graphics is wanted, there is utouch-frame. For low-level testing, the
mtdev project can be used, or even evtest.

Thanks,
Henrik

[1] https://launchpad.net/mtview/, or http://bitmath.org/code/mtview/
