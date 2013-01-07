Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3AGKtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:49:04 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:47519 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab3AGKtC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:49:02 -0500
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 7 Jan 2013 11:48:51 +0100
Subject: RE: [PATCH 02/25] ab8500_charger: don't use [delayed_]work_pending()
Thread-Topic: [PATCH 02/25] ab8500_charger: don't use
 [delayed_]work_pending()
Thread-Index: Ac3swvKOg6ohXVVHRhKLNG5TXerbZgAAUv4w
Message-ID: <F45880696056844FA6A73F415B568C695BB0CDD1C8@EXDCVYMBSTM006.EQ1STM.local>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-3-git-send-email-tj@kernel.org>
 <CACRpkdYE3F22rnW+ZRhOWT4VGRhG2CSnb7Rj3gdCosTK8wLQmA@mail.gmail.com>
 <50EAA53F.1000304@stericsson.com>
In-Reply-To: <50EAA53F.1000304@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> >
> > Remove unnecessary pending tests from ab8500_charger.  Only compile
> > tested.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> > Cc: Linus Walleij <linus.walleij@linaro.org>

Acked-By: Arun Murthy <arun.murthy@stericsson.com>

Thanks and Regards,
Arun R Murthy
------------------
