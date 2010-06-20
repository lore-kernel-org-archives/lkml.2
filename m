Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756968Ab0FTT1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 15:27:20 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58603 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab0FTT1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 15:27:19 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>, Yinghai Lu <yinghai@kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "akpm@osdl.org" <akpm@osdl.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jun 2010 13:27:01 -0600
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
  Enable Online Controller Reset Bit in register related functions
Thread-Topic: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
  Enable Online Controller Reset Bit in register related functions
Thread-Index: AcsQiWu8reKYArYXSIWRF12KOg80HwAJKneA
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
 <1277046060.5242.18.camel@mulgrave.site>
In-Reply-To: <1277046060.5242.18.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5KJRgim019887

James,

The online controller reset (OCR) need to apply [Patch 1/12  --  patch 8/12].  I already submitted all of them.

Regards,

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Sunday, June 20, 2010 11:01 AM
To: Yinghai Lu
Cc: Yang, Bo; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I: Enable Online Controller Reset Bit in register related functions

On Fri, 2010-06-18 at 14:18 -0700, Yinghai Lu wrote:
> On Wed, Jun 9, 2010 at 7:34 PM, Yang, Bo <Bo.Yang@lsi.com> wrote:
> > Enable the Online Controller reset bit in the register related functions.  This is first part of the Online Controller Reset.
> > The driver supports XScle and Gen2 chips.  Driver need to read the FW state register to see if there is FW state change
> > Happen.
> >
> > Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> This patch cause kernel hang just after
> [  136.996297] megasas: FW now in Ready state

OK, I dropped all the megaraid_sas patches for now ... I'll reapply once
we get the bisection intervals sorted out.

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
