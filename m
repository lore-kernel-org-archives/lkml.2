Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771Ab0HLPVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:21:01 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40559 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600Ab0HLPU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:20:57 -0400
From: "Yang, Bo" <Bo.Yang@lsi.com>
To: James Bottomley <James.Bottomley@suse.de>
CC: Yinghai Lu <yinghai@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Maharana, Parag" <Parag.Maharana@lsi.com>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
Date: Thu, 12 Aug 2010 09:20:39 -0600
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Thread-Topic: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Thread-Index: Acsw2E0UU5zHj3F8SMOoBE3QdnJBMAJWWdvQ
Message-ID: <4B6A08C587958942AA3002690DD4F8C3DBE6239A@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
	 <1277066924.5242.41.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
 <1280598371.2801.11.camel@mulgrave.site>
In-Reply-To: <1280598371.2801.11.camel@mulgrave.site>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7CFL53u011916

James,

Just let you know the new patches already submitted yesterday.  Please let me know after you updated those patches to the main tree.

Regards,

Bo Yang

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Saturday, July 31, 2010 1:46 PM
To: Yang, Bo
Cc: Yinghai Lu; linux-scsi@vger.kernel.org; akpm@osdl.org; linux-kernel@vger.kernel.org; Maharana, Parag; Daftardar, Jayant
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I: Enable Online Controller Reset Bit in register related functions

On Fri, 2010-07-30 at 12:53 -0600, Yang, Bo wrote:
> Do you know when those patches (12 patches) will be pushed to upstream?

Well, it looks like I lost the branch I was fixing all this up in
somewhere.  I don't really have time to redo that work, so could you
send the series correctly (that's the 8 OCR patches that don't
individually compile as a single patch with a correct changelog plus the
four others).

Thanks,

James


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
