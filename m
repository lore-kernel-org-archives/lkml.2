Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1KJIWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:22:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48620 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab1KJIWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:22:43 -0500
X-AuditID: cbfee61b-b7b7fae000005864-d7-4ebb89d1ec19
From: Chanho Park <chanho61.park@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Stephen Warren'" <swarren@nvidia.com>, Barry.Song@csr.com,
        Rongjun.Ying@csr.com, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1319780504-23816-1-git-send-email-chanho61.park@samsung.com>
 <74CDBE0F657A3D45AFBB94109FB122FF173EDAB4A3@HQMAIL01.nvidia.com>
 <02cf01cc993d$4c484040$e4d8c0c0$%park@samsung.com>
 <CACRpkdZ80Tj_ttsQTAZAUT4X_UfQi9PDn2Tjc35jT62nBd496A@mail.gmail.com>
In-reply-to: <CACRpkdZ80Tj_ttsQTAZAUT4X_UfQi9PDn2Tjc35jT62nBd496A@mail.gmail.com>
Subject: RE: [PATCHv2] drivers: pinctrl: add a pin_base for sparse gpio-ranges
Date: Thu, 10 Nov 2011 17:22:03 +0900
Message-id: <00e701cc9f81$d3a6bfe0$7af43fa0$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyfgAlyzEVo9oSPQWWLJxgxBxcDrQAAbdAw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus.
Our smtp server blocked my email. :)
I'll submit v3 patch soon. (Maybe tomorrow)
Thank you.

Best Regards,
Chanho Park

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Linus Walleij
> Sent: Thursday, November 10, 2011 5:08 PM
> To: Chanho Park
> Cc: Stephen Warren; Barry.Song@csr.com; Rongjun.Ying@csr.com; linux-
> kernel@vger.kernel.org; Kyungmin Park
> Subject: Re: [PATCHv2] drivers: pinctrl: add a pin_base for sparse
> gpio-ranges
> 
> On Wed, Nov 2, 2011 at 9:56 AM, Chanho Park <chanho61.park@samsung.com>
> wrote:
> 
> >> You'll need to update that documentation now that the final
> parameter is
> >> a pin number, not an offset into the range.
> >
> > I'll update it. Thx.
> 
> Chanho, do you have a v3 ready? I'd really like to apply this patch...
> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

