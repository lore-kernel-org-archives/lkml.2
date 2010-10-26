Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137Ab0JZRPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:15:39 -0400
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45981 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758203Ab0JZRPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:15:38 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>
CC: bo yang <boyang1288@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 26 Oct 2010 11:15:08 -0600
Subject: RE: [PATCH 5/5] scsi: megaraid_sas - Version and documentation
 update
Thread-Topic: [PATCH 5/5] scsi: megaraid_sas - Version and documentation
 update
Thread-Index: Act1KJkKQ0uvtAe3R5S/DxEnQsgVngABEFtw
Message-ID: <4B6A08C587958942AA3002690DD4F8C3010119E798@cosmail02.lsi.com>
References: <AANLkTi=praySm1B3dhU+LxhWK2yUccZkzWpd6-6UERYa@mail.gmail.com>
	 <4B6A08C587958942AA3002690DD4F8C30100FF9FBB@cosmail02.lsi.com>
 <1288109543.8283.139.camel@mulgrave.site>
In-Reply-To: <1288109543.8283.139.camel@mulgrave.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o9QHFvC5012196

James,

Thanks for correcting that. Did you also applied 2/5, 3/5 and 4/5 patches?

By the way, I always use checkpatch.pl to check the patch before I attach the patch to the e-mail.  Also I just went to the 5/5 patch to verify the patch: the steps:

1. go to  http://marc.info/?l=linux-scsi&m=128688974201201&w=2 
2. click: ["megasas-version.patch" (application/octet-stream)] to download this patch.  
3. Used the checkpatch.pl to check (I used the cmd: "checkpatch.pl --no-tree megasas-version.patch") 

It looks OK for me (no errors).  It is maybe the checkpatch.pl I used does not get updated or some steps are not correct.  I will find out the updated one to try and find out the reasons.   


Thanks,

Bo Yang


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Tuesday, October 26, 2010 12:12 PM
To: Yang, Bo
Cc: bo yang; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] scsi: megaraid_sas - Version and documentation update

On Tue, 2010-10-12 at 07:21 -0600, Yang, Bo wrote:
> Re-Submit:
> 
> Update the version and documentation.

This has an impressive set of checkpatch failures:

ERROR: trailing whitespace
#26: FILE: Documentation/scsi/ChangeLog.megaraid_sas:13:
+^ITo add the OCR support, driver need to do: $

ERROR: trailing whitespace
#30: FILE: Documentation/scsi/ChangeLog.megaraid_sas:17:
+^I^I$

ERROR: trailing whitespace
#35: FILE: Documentation/scsi/ChangeLog.megaraid_sas:22:
+^I^I$

ERROR: trailing whitespace
#39: FILE: Documentation/scsi/ChangeLog.megaraid_sas:26:
+^I^I$

ERROR: trailing whitespace
#43: FILE: Documentation/scsi/ChangeLog.megaraid_sas:30:
+^I^I$

ERROR: trailing whitespace
#46: FILE: Documentation/scsi/ChangeLog.megaraid_sas:33:
+^I^I $

ERROR: trailing whitespace
#48: FILE: Documentation/scsi/ChangeLog.megaraid_sas:35:
+^I^IOCR to see if driver can bring back the FW.      $

ERROR: trailing whitespace
#54: FILE: Documentation/scsi/ChangeLog.megaraid_sas:41:
+3.^IIn driver's timeout routine, driver will do three time reset if fw
is in $

total: 8 errors, 0 warnings, 70 lines checked

I've fixed it up this time, but could you run it through checkpatch.pl
next time?

Thanks,

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
