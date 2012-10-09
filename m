Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2JIOPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:15:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45321 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2JIOPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:15:36 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <20121009132847.GC4587@mwanda>
References: <20121001024544.GA12711@localhost> <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com> <20121009132847.GC4587@mwanda>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 9 Oct 2012 16:15:15 +0200
Message-ID: <CAK=WgbadhpEaP=ObM8rT=+xnEmh3xzb_ORThDfutH+jDOCf2mQ@mail.gmail.com>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 3:28 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Unless there is a good reason why

That's what I'm asking. Is there an inherent coupling with some
platform/architecture ? E.g., OMAP remote processors only go with
OMAP chips.
