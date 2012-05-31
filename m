Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab2EaB6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 21:58:41 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64217 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2EaB6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 21:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <F45880696056844FA6A73F415B568C69595AD0E365@EXDCVYMBSTM006.EQ1STM.local>
References: <1337590701-17056-1-git-send-email-arun.murthy@stericsson.com>
	<F45880696056844FA6A73F415B568C69595AD0E365@EXDCVYMBSTM006.EQ1STM.local>
Date: Thu, 31 May 2012 09:58:39 +0800
Message-ID: <CACRpkda916-6ArCb4jVdrhOizNcet9S7j_whGzoOv35CYEYyNw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mfd: db8500-prcmu: update hostport_access enable
From: Linus Walleij <linus.walleij@linaro.org>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 1:32 PM, Arun MURTHY <arun.murthy@stericsson.com> wrote:

>> Force the Modem wakeup by asserting the CaWakeReq signal before the
>> hostaccess_req/ack ping-pong sequence. The Awake_req signal is de-
>> asserted
>> asserted at the same time than the hostaccess_req. Return error on
>> failure
>> case so that the client using this can take appropiate steps.
>>
>> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
>> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
>> ---
>
>
> Any Comments?

Have you checked that this applies cleanly to the latest v3.5 HEAD from
Torvalds? I think I tried applying at one point and it didn't work.

Otherwise I think it's ripe for Sam to apply?

Yours,
Linus Walleij
