Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab2JBIZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:25:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41405 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2JBIZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:25:05 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <20121001024544.GA12711@localhost>
References: <20121001024544.GA12711@localhost>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 2 Oct 2012 10:24:45 +0200
Message-ID: <CAK=WgbakTOS71tvpQDLoANm25Ms_sbz1OcEqBuvO2+ZKwMBsmA@mail.gmail.com>
Subject: Re: [remoteproc:for-next 6/9] remoteproc_virtio.c:(.text+0x238e7e):
 undefined reference to `vring_transport_features'
To: Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 4:45 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Ohad,
>
> FYI, kernel build failed on
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next
> head:   bec109a430e8c67bae1743f7e71898283234a77f
> commit: ec4d02d9180f407c41f8310a13b34e473c671fbb [6/9] remoteproc: Add STE modem driver
> config: i386-randconfig-b102 (attached as .config)
>
> It should be an old bug. The commit happen to be the one to trigger
> the errors because it selects CONFIG_EMOTEPROC.

Thanks Fengguang.

This should be fixed by a patch I pushed today to remoteproc's for-next branch.

Though I wonder, Sjur, do we want to limit the architectures/platforms
where the STE modem driver can be selected on ? Is it ARM only perhaps
?
