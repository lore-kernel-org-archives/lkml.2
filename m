Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0GBHJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 03:09:00 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37197 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0GBHI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 03:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WFIkxcBHHbc/F3aA7qw2+LFAXuiESvSLOfzPPMW37b4qzk3pTebETcQ2Z8eiFw0nqA
         BP26g4jQ//gDZCuY3+HsDRzUUpld/SmHwmHdoQkjU+XQRmMNScajk4VR6pKom5f+1aJt
         9+VX7sfZHNGrnnK9MjOn8LpzLnEQHlXWNXd3Y=
MIME-Version: 1.0
In-Reply-To: <20100701130724.GC17698@sirena.org.uk>
References: <cover.1277911345.git.siccegge@cs.fau.de>
	<e5391de6858597bbfd43874aed124a73f74850b5.1277911346.git.siccegge@cs.fau.de>
	<AANLkTinZa7_TEjYFTu9V6obndpVvMmHppaOArM1AJg_t@mail.gmail.com>
	<20100701130724.GC17698@sirena.org.uk>
Date: Fri, 2 Jul 2010 16:08:56 +0900
Message-ID: <AANLkTim0usB99K6orH0lxP73e-XK69ytdECtR5D1dPJt@mail.gmail.com>
Subject: Re: [PATCH 29/33] Removing dead SND_SOC_SMDK2443_WM9710
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Christoph Egger <siccegge@cs.fau.de>, Ben Dooks <ben-linux@fluff.org>,
       Russell King <linux@arm.linux.org.uk>,
       Jassi Brar <jassi.brar@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 10:07 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Jul 01, 2010 at 09:55:47PM +0900, Jassi Brar wrote:
>> On Thu, Jul 1, 2010 at 1:03 AM, Christoph Egger <siccegge@cs.fau.de> wrote:
>> > SND_SOC_SMDK2443_WM9710 doesn't exist in Kconfig, therefore removing
>> > all references for it from the source code.
>
>> I'd rather have the code compiled unconditionally.
>
> Hrm, if this is part of the default hardware build we should get the
> driver merged.
But the machine driver is already there
   sound/soc/s3c24xx/smdk2443_wm9710.c
