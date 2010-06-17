Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab0FQRBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:01:09 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:39192 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933084Ab0FQRBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:01:06 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>
CC: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
       "'akpm@osdl.org'" <akpm@osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Jun 2010 11:00:48 -0600
Subject: RE: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset
 (OCR): Add and initialize the OCR relaed variable
Thread-Topic: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset
 (OCR): Add and initialize the OCR relaed variable
Thread-Index: AcsOOOwFjojY4gTVRIKSKEs+F2YnHAABY7Kg
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D0926EE5@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
 <1276791570.7398.12.camel@mulgrave.site>
In-Reply-To: <1276791570.7398.12.camel@mulgrave.site>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5HH1Nim020221

James,

Thanks, I will re-submit the patches 5-12.

Regards,

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Thursday, June 17, 2010 12:20 PM
To: Yang, Bo
Cc: 'linux-scsi@vger.kernel.org'; 'akpm@osdl.org'; 'linux-kernel@vger.kernel.org'
Subject: Re: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset (OCR): Add and initialize the OCR relaed variable

On Wed, 2010-06-09 at 21:54 -0600, Yang, Bo wrote:
> To support online controller reset, driver need to define some
> instance based variable and initialize them.

This doesn't compile:

  CC [M]  drivers/scsi/megaraid/megaraid_sas.o
drivers/scsi/megaraid/megaraid_sas.c: In function
â€˜megasas_deplete_reply_queueâ€™:
drivers/scsi/megaraid/megaraid_sas.c:2090: warning: unused variable
â€˜fw_stateâ€™
drivers/scsi/megaraid/megaraid_sas.c: In function â€˜megasas_init_mfiâ€™:
drivers/scsi/megaraid/megaraid_sas.c:3023: error: â€˜struct
megasas_ctrl_propâ€™ has no member named â€˜OnOffPropertiesâ€™
drivers/scsi/megaraid/megaraid_sas.c: In function â€˜megasas_probe_oneâ€™:
drivers/scsi/megaraid/megaraid_sas.c:3486: error:
â€˜process_fw_state_change_wqâ€™ undeclared (first use in this function)
drivers/scsi/megaraid/megaraid_sas.c:3486: error: (Each undeclared
identifier is reported only once
drivers/scsi/megaraid/megaraid_sas.c:3486: error: for each function it
appears in.)

Because OnOffProperties structure is defined in patch 6/12 as is the
process_fw_state_change_wq function.

I've got 1-4 ... please resubmit 5-12 so they actually build in the
order submitted.

Thanks,

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
