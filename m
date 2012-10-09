Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2JIO1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:27:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39553 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab2JIO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:27:29 -0400
Date: Tue, 9 Oct 2012 17:26:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Sjur BRENDELAND <sjur.brandeland@stericsson.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
Message-ID: <20121009142644.GD4587@mwanda>
References: <20121001024544.GA12711@localhost>
 <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
 <CAK=WgbYK2rFw7iFV1fGUb1saXrsH+yh=2Etmuj5+6ob6cCKntw@mail.gmail.com>
 <81C3A93C17462B4BBD7E272753C1057923BD9B59E3@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbaNHBVeF_A0jyNpRvnsO_BbkJGxKzyroC6pO1x+OELe0w@mail.gmail.com>
 <20121009132847.GC4587@mwanda>
 <CAK=WgbadhpEaP=ObM8rT=+xnEmh3xzb_ORThDfutH+jDOCf2mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=WgbadhpEaP=ObM8rT=+xnEmh3xzb_ORThDfutH+jDOCf2mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:15:15PM +0200, Ohad Ben-Cohen wrote:
> On Tue, Oct 9, 2012 at 3:28 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Unless there is a good reason why
> 
> That's what I'm asking. Is there an inherent coupling with some
> platform/architecture ? E.g., OMAP remote processors only go with
> OMAP chips.

If it already compiles fine on x86 then there is no advantage to
disabling it.

regards,
dan carpenter

