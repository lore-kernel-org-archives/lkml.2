Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0JHNrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:47:46 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55356 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab0JHNro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:47:44 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>, bo yang <boyang1288@gmail.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Date: Fri, 8 Oct 2010 07:47:25 -0600
Subject: RE: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
Thread-Topic: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
Thread-Index: ActmpffF+7OAVZOjS4WdFwHHR7NsHQASCvgw
Message-ID: <4B6A08C587958942AA3002690DD4F8C30100F54C90@cosmail02.lsi.com>
References: <AANLkTim3OKvhov1uCj5g6YgmOzR1rDogLmtJMTkbYq5V@mail.gmail.com>
 <1286490947.23573.3.camel@mulgrave.site>
In-Reply-To: <1286490947.23573.3.camel@mulgrave.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o98DlvZ5003785

James,

Thanks for getting the online controller reset in.  I downloaded patch 2/5 from  http://marc.info/?l=linux-scsi&m=128521127203199&w=2 and I can apply it without errors.

Can you try it again?  otherwise I need to re-attach it.

Thanks,

Bo Yang    

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Thursday, October 07, 2010 6:36 PM
To: bo yang
Cc: Yang, Bo; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] scsi: megaraid_sas - support devices update flag

On Wed, 2010-09-22 at 22:50 -0400, bo yang wrote:
> Driver added the Device update flag to tell LSI application driver
> will do the device Update.  LSI MegaRAID SAS application will check
> this flag to decide if it is need to update the Device or not.

Well, the good news is I've got the Online Controller reset update. The
bad news is that this patch now fails to apply: looks like an attachment
problem again:

Applying: megaraid_sas: support devices update flag
fatal: corrupt patch at line 70
Patch failed at 0001 megaraid_sas: support devices update flag

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
