Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2FDGWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:22:20 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:47656 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219Ab2FDGWT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:22:19 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Date: Mon, 4 Jun 2012 08:21:25 +0200
Subject: RE: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Thread-Topic: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
Thread-Index: Ac0+0Oa2pz9OqBGaRhG9YdIODWMcXgDPod6A
Message-ID: <F45880696056844FA6A73F415B568C69595AD891F5@EXDCVYMBSTM006.EQ1STM.local>
References: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
	<F45880696056844FA6A73F415B568C69595AD0E365@EXDCVYMBSTM006.EQ1STM.local>
 <CACRpkda916-6ArCb4jVdrhOizNcet9S7j_whGzoOv35CYEYyNw@mail.gmail.com>
In-Reply-To: <CACRpkda916-6ArCb4jVdrhOizNcet9S7j_whGzoOv35CYEYyNw@mail.gmail.com>
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

> >> Force the Modem wakeup by asserting the CaWakeReq signal before the
> >> hostaccess_req/ack ping-pong sequence. The Awake_req signal is de-
> >> asserted
> >> asserted at the same time than the hostaccess_req. Return error on
> >> failure
> >> case so that the client using this can take appropiate steps.
> >>
> >> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> >> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> >> ---
> >
> >
> > Any Comments?
> 
> Have you checked that this applies cleanly to the latest v3.5 HEAD from
> Torvalds? I think I tried applying at one point and it didn't work.
> 
> Otherwise I think it's ripe for Sam to apply?
> 

The patch applies as is with no conflict.

Thanks and Regards,
Arun R Murthy
-------------
