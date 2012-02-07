Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2BGIkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 03:40:06 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29220 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2BGIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 03:40:04 -0500
X-AuditID: cbfee61b-b7be3ae0000039aa-39-4f30e361046c
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Chris Ball'" <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Namjae Jeon'" <linkinjeon@gmail.com>
References: <000901ccdc09$92daf020$b890d060$%jun@samsung.com>
 <m2obte86qi.fsf@bob.laptop.org>
In-reply-to: <m2obte86qi.fsf@bob.laptop.org>
Subject: RE: [PATCH v4 0/2] mmc: core: Support packed command feature of eMMC4.5
Date: Tue, 07 Feb 2012 17:40:00 +0900
Message-id: <001201cce574$14b7d220$3e277660$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczjnPpDGYfz9m0lQEuGttJ70Ek+/gBjXLnA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Chris Ball <cjb@laptop.org> wrote:
> Hi Seungwon,
> 
> On Thu, Jan 26 2012, Seungwon Jeon wrote:
> > This patch-set adds support of packed command feature
> > for eMMC4.5 devices.
> 
> Thanks, looks good!  Were you or Namjae able to measure any performance
> changes with this patchset applied?
We could get the difference results depending on eMMC device.
I have tested patch set with eMMC device which was not optimized in packed command.
In my environment there is a performance gain only with packed write
if total chunk size for transfer is large.
This is not common case in user scenario as of now.
Currently this patch set with regard to packed command is meaningful
and helpful for device supporting fully.

Best regards,
Seungwon Jeon.

> 
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

