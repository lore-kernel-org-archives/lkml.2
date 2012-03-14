Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab2CNXjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 19:39:18 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27382 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760715Ab2CNXjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 19:39:14 -0400
From: "Nanjappa, Sathisha (MCXS, Cupertino)" <sathisha.nanjappa@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Topic: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Index: AQHNAb0kYPKk1kFKbUOL9EWnl0kcTpZqbNNg
Date: Wed, 14 Mar 2012 23:36:51 +0000
Message-ID: <C8A4A375313D4E4DA64F2CB1D0490B0A44730306@G9W0735.americas.hpqcorp.net>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
	 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
 <1331714014.8688.3.camel@dabdike>
In-Reply-To: <1331714014.8688.3.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2ENdQS5031800

> 
> On Tue, 2012-03-13 at 11:59 -0700, Sathisha Nanjappa wrote:
> > Bugzilla 42142 - mpt2sas: Number specified in wrong base
> >     https://bugzilla.kernel.org/show_bug.cgi?id=42142
> 
> From: James Bottomley
> Sent: Wednesday, March 14, 2012 1:34 AM
> Do you have a better description ... like what is the user
> visible effect of correcting the constant?
>

Does this look better:

"This fix ensures that the IOP_LOGINFO_CODE_TASK_TERMINATED
messages do not clutter the sas_log_info messages."

Thanks,
-Satish.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
