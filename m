Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab0FJOlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:41:10 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:59981 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759276Ab0FJOlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:41:07 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 Jun 2010 16:40:53 +0200
Subject: RE: [PATCH] mfd: Staticise ab3550 register access functions
Thread-Topic: [PATCH] mfd: Staticise ab3550 register access functions
Thread-Index: AcsH217zKxAuuw9BTk6h6NkWHkN9hAAz3oHQ
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A9F90C5@EXDCVYMBSTM006.EQ1STM.local>
References: <1276091694-31331-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1276091694-31331-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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

[Mark Brown]
> These are now exported via an ops table rather than referenced
> directly and so should be staticised.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
