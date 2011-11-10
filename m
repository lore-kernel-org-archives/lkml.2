Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab1KJIIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:08:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933830Ab1KJIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <02cf01cc993d$4c484040$e4d8c0c0$%park@samsung.com>
References: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
	<74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A3@HQMAIL01.nvidia.com>
	<02cf01cc993d$4c484040$e4d8c0c0$%park@samsung.com>
Date: Thu, 10 Nov 2011 09:08:06 +0100
Message-ID: <CACRpkdZ80Tj_ttsQTAZAUT4X_UfQi9PDn2Tjc35jT62nBd496A@mail.gmail.com>
Subject: Re: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-ranges
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <chanho61.park@samsung.com>
Cc: Stephen Warren <swarren@nvidia.com>, Barry.Song@csr.com,
        Rongjun.Ying@csr.com, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 9:56 AM, Chanho Park <chanho61.park@samsung.com> wrote:

>> You'll need to update that documentation now that the final parameter is
>> a pin number, not an offset into the range.
>
> I'll update it. Thx.

Chanho, do you have a v3 ready? I'd really like to apply this patch...

Yours,
Linus Walleij
