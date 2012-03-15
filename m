Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161203Ab2CORzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:55:18 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9546 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161079Ab2CORzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:55:14 -0400
From: "Nanjappa, Sathisha (MCXS, Cupertino)" <sathisha.nanjappa@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Dunlop <chris@onthe.net.au>,
        "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Topic: [PATCH] mpt2sas: Corrected the constant in comparison to a
 hexadecimal.
Thread-Index: AQHNAb0kYPKk1kFKbUOL9EWnl0kcTpZqbNNggACizACAAJQhAA==
Date: Thu, 15 Mar 2012 17:54:56 +0000
Message-ID: <C8A4A375313D4E4DA64F2CB1D0490B0A44731B27@G9W0735.americas.hpqcorp.net>
References: <1331665168-22561-1-git-send-email-sathisha.nanjappa@hp.com>
	 <1331665168-22561-2-git-send-email-sathisha.nanjappa@hp.com>
	 <1331714014.8688.3.camel@dabdike>
	 <C8A4A375313D4E4DA64F2CB1D0490B0A44730306@G9W0735.americas.hpqcorp.net>
 <1331801806.2941.3.camel@dabdike>
In-Reply-To: <1331801806.2941.3.camel@dabdike>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2FHtKNK005599

> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of James Bottomley
> Sent: Thursday, March 15, 2012 1:57 AM
> 
> On Wed, 2012-03-14 at 23:36 +0000, Nanjappa, Sathisha (MCXS, Cupertino)
> wrote:
> > >
> > > On Tue, 2012-03-13 at 11:59 -0700, Sathisha Nanjappa wrote:
> > > > Bugzilla 42142 - mpt2sas: Number specified in wrong base
> > > >     https://bugzilla.kernel.org/show_bug.cgi?id=42142
> > >
> > > From: James Bottomley
> > > Sent: Wednesday, March 14, 2012 1:34 AM
> > > Do you have a better description ... like what is the user
> > > visible effect of correcting the constant?
> > >
> >
> > Does this look better:
> >
> > "This fix ensures that the IOP_LOGINFO_CODE_TASK_TERMINATED
> > messages do not clutter the sas_log_info messages."
> 
> Much better, thanks.  The whole point of a commit message is to explain
> what you're doing and why you're doing it.  Just translating C to
> english isn't useful because everyone who looks a kernel patches can
> read C.
> 

Thanks for clarifying. I'll keep that in mind during my future submittal requests.

FYI, I've received ack's from:

Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Acked-by: "Chris Dunlop" <chris@onthe.net.au> 

-Satish.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
