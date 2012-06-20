Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab2FTCCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 22:02:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55265 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2FTCCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 22:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FE0AE7B.4040502@gmail.com>
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com>
	<CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com>
	<CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com>
	<CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
	<4FE0AE7B.4040502@gmail.com>
Date: Wed, 20 Jun 2012 10:02:35 +0800
Message-ID: <CACVXFVPgfVaEQGCaCOxLTKov3RcBe8AxSR12GFNMBBN5CTbgaw@mail.gmail.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
From: Ming Lei <ming.lei@canonical.com>
To: Paolo Pisati <p.pisati@gmail.com>
Cc: "T Krishnamoorthy, Balaji" <balajitk@ti.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 12:53 AM, Paolo Pisati <p.pisati@gmail.com> wrote:
> On 06/13/2012 05:28 PM, T Krishnamoorthy, Balaji wrote:
>> Couldn't reproduce the issue with BeagleXM rev C, Might be a combination
>> of rev and SD card. How often do you see mis-match in file content?
>
> i just want to say that i'm affected by this too, and i can reproduce it
> 100%.

So it is not only me affected by the commit.

Considered it is a serious problem(just several kernel boots may
destroy the rootfs on my board) and no any progress obtained since
report, I will send a patch to revert the commit to avoid more victims.


Thanks,
--
Ming Lei
