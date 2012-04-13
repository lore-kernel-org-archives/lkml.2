Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab2DMImk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:42:40 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:36037 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab2DMImi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:42:38 -0400
From: Arun MURTHY <arun.murthy@stericsson.com>
To: Linus WALLEIJ <linus.walleij@stericsson.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Karl KOMIEROWSKI <karl.komierowski@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 13 Apr 2012 10:42:59 +0200
Subject: RE: [PATCH 1/3] power/ab8500_charger: harden platform data check
Thread-Topic: [PATCH 1/3] power/ab8500_charger: harden platform data check
Thread-Index: Ac0ZTao44LlhAEgXQ1mie7ENjnVAdwAA4hHQ
Message-ID: <F45880696056844FA6A73F415B568C695929A08445@EXDCVYMBSTM006.EQ1STM.local>
References: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1334304949-18301-1-git-send-email-linus.walleij@stericsson.com>
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

> From: Linus Walleij <linus.walleij@linaro.org>
> 
> If no platform data at all is supplied the driver crashes,
> extend the checks to be more careful so we can compile in the
> driver and boot also without platform data present.
> 
> Cc: Arun Murthy <arun.murthy@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Acked-by: Arun Murthy <arun.murthy@stericsson.com>

