Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1IVQfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:35:22 -0400
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:30288 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750874Ab1IVQfV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:35:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 898746.13531.bm@omp1005.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Xnyp6XisUdLzCIBY7EclGZFQbrUdaFnnh+14e4VzffN7aNIo6EegTq1dBdfIoiEJXIVrGbbcjNrZslI1h8qzLpDbjdjAxp3mDTqdGf1VxgDBIjX/jf+lFOY1Awrgh4KvNu2sokuJrDgVYeqg3/Wh1o89o1eKBq65RNgb5Dz4f54=;
X-YMail-OSG: bAoxfq4VM1m1ggfQUbcU.SZpR2nPPwu8agpsvXf20.PPQZk
 z6mOf75J2kf9QGjs34ID1kUJJnif.Mae4IZmYMjWRxBjPR.v.RPe_7Saoxcx
 McK.43oEf4.GCwG2oB4BCVuVlavDBigqmMO87yN20ye9J9NbyOg1GOmD4nuf
 8ogm8bi5pXhv1fVBaIh0xFuFI59ACCPbzgjT01hVZQlg0xp3hegoq0frkmB2
 pvDvUwJ43ISjuVg9g55FWDpxLoGK4KIneMpPwjHFjH8TDqqM0Pi2Y3uJOiT4
 k2DFEvasXNVzi4Rf6CNMS86mjAFPiuoZaUwuBVVepPVN831OCzFftgJUNtTv
 Ah8TCIPPg61m5FKy1.GEzXuBVJfvOxG1EeTaTKw7JclhKgE_jqWYZgELGx63
 It6SdhLbXjqeDF9_1TWb7pVdUv9O9P_a2OKryw5YYrrEXV4QDfdQHWAhXMhs
 4aW5MwvZt_vUA83_i1yYjprnSJhehclB4cFFKs8ZYCzfWveK3Ox7iwQdhW0P
 yBnH1sJY6zf5yIfVViQKVfn.OV75WYskZ
X-Mailer: YahooMailWebService/0.8.114.317681
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Message-ID: <1316709319.79868.YahooMailNeo@web31804.mail.mud.yahoo.com>
Date: Thu, 22 Sep 2011 09:35:19 -0700 (PDT)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>,
        James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        Jack Wang <jack_wang@usish.com>
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Salyzyn, DON'T do this any more with mine or anybody else's patches. OKAY?



----- Original Message -----
> From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> To: James Bottomley <jbottomley@parallels.com>; Luben Tuikov <ltuikov@yahoo.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Darrick Wong <djwong@us.ibm.com>; Xiangliang Yu <yuxiangl@marvell.com>; Jack Wang <jack_wang@usish.com>
> Sent: Thursday, September 22, 2011 8:04 AM
> Subject: RE: [PATCH] [SCSI] libsas: Allow expander T-T attachments
> 
> Enclosed is an updated patch that passes checkpatch.pl (a few 80-character line 
> errors in the original), maintain existing indent mechanics and contains my 
> 'Ack' and the recommended Cc list.
> 
> Wait for Luben's Ack or Override (despite the fact I took the liberty of 
> adding his Signed-off-by on the checkpatch required adjustments).
> 
> Sincerely -- Mark Salyzyn 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] 
> On Behalf Of James Bottomley
> Sent: Thursday, September 22, 2011 7:30 AM
> To: Luben Tuikov
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
> 
> On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
>>  Allow expander table-to-table attachments for
>>  expanders that support it.
>> 
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> OK, so now I need an applyable patch, please.  It looks like the mail
> server has mapped all tabs to spaces.  If you can't fix the mailer, just
> sending the patch as an attachment is fine.
> 
> James
> 
> NrybXǧv^)޺{.n+{"{ayʇڙ,j fhzwj:+vwjm zZ+ݢj"!
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which should only 
> be used for the purpose for which it was sent by Xyratex. No further rights or 
> licenses are granted to use such information. If you are not the intended 
> recipient of this message, please notify the sender by return and delete it. You 
> may not use, copy, disclose or rely on the information contained in it.
> 
> Internet email is susceptible to data corruption, interception and unauthorised 
> amendment for which Xyratex does not accept liability. While we have taken 
> reasonable precautions to ensure that this email is free of viruses, Xyratex 
> does not accept liability for the presence of any computer viruses in this 
> email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales, 
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in 
> Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) 
> Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in 
> The People's Republic of China and Xyratex Japan Limited registered in 
> Japan.
> ______________________________________________________________________
>
