Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab1IVQg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:36:26 -0400
Received: from nm34-vm4.bullet.mail.bf1.yahoo.com ([72.30.239.76]:27005 "HELO
	nm34-vm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751251Ab1IVQgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:36:25 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Sep 2011 12:36:25 EDT
X-Yahoo-Newman-Id: 974724.31939.bm@omp1043.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:References:Mime-Version:In-Reply-To:X-Apple-Yahoo-Original-Message-Folder:Content-Type:Content-Transfer-Encoding:Message-Id:Cc:X-Mailer:From:X-Apple-Yahoo-Replied-Msgid:Subject:Date:To;
  b=WqYLevIfZ3Gve11v2ZpXWs33bX8pkDmkZAFFRLpbxoyUOV9GFaiGjK67tRzpo+z5Se0w/Ozw8QnXquDSABed8Fg+CknXfJGUAVkd8xIB2t9+cllqmSkO0vi3xgXbbMk6AB3BgC2IfmjSZ9PCFV1xeSokckbaSDZgHtyGXdy4YQE=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IGgCZl0VM1lMWWCngtiJ3TF_oAoI5UkhHc28vQf5F7cd5JZ
 oI8ZLZ173Epyh3y3hlVK7IBgAj4CwKfbaQHD_J9r1CHDwdQClxML32nLU6pQ
 jDE8JtSrdtQbnK7Ktg.6X0X2pRsSoEOkGTw0jhY110aBEXn9TT_g0g2mHrDX
 w5RFcQAW7pRoPvVqrVjWd0N1CxWvCwv.eh9E.2_i6TzUKjopfYPimp2bk1mq
 vU81VKtyAUNNEkde0eyQRaHqDm8oZ.7vnwKVdWbSvQf1I9pmRWN8S2NbYwuD
 RX.L8MxxdhX73EcV3thYMch9REoSK.4No6vTehByWvjmEO1SoGR_MQqadhsi
 N14Pdm9EjP2W_bB8K95RiuIFvQD4w_ZyLZU5AYAku.xgZHFZtNc_.1_9ipcg
 CklzLrTUzmCe8Iv1W4Owgfmdx2ZiXgchMvGah7UsHTcbb0yNah4hjXHk73NH
 CTnTaTLokydc828_quHR2VKratBmGsuc.oLiX2.kXjsU-
X-Yahoo-SMTP: Jr5mEQOswBBUeQ6oSnePwwxoZ1M-
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
X-Apple-Yahoo-Original-Message-Folder: Inbox
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <76417E04-4E3A-4064-A936-CEF12A8B674E@yahoo.com>
Cc: James Bottomley <jbottomley@parallels.com>,
        "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>,
        Jack Wang <jack_wang@usish.com>
X-Mailer: iPhone Mail (8J2)
From: Luben Tuikov <ltuikov@yahoo.com>
X-Apple-Yahoo-Replied-Msgid: 1_7722044_AETPjkQAAPXmTntO/gQLNkqqNcg
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 09:30:39 -0700
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isn't this my own patch? Shouldn't have I regenerated it and sent of off? Is it common here to have other people generate other people's patches? I think that not very professional. 

James, you should apply the patch I'm about to send. Same one, tabs fixed. 

        Luben


On Sep 22, 2011, at 8:04, "Mark Salyzyn" <mark_salyzyn@us.xyratex.com> wrote:

> Enclosed is an updated patch that passes checkpatch.pl (a few 80-character line errors in the original), maintain existing indent mechanics and contains my 'Ack' and the recommended Cc list.
> 
> Wait for Luben's Ack or Override (despite the fact I took the liberty of adding his Signed-off-by on the checkpatch required adjustments).
> 
> Sincerely -- Mark Salyzyn 
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
> Sent: Thursday, September 22, 2011 7:30 AM
> To: Luben Tuikov
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
> 
> On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
>> Allow expander table-to-table attachments for
>> expanders that support it.
>> 
>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> 
> OK, so now I need an applyable patch, please.  It looks like the mail
> server has mapped all tabs to spaces.  If you can't fix the mailer, just
> sending the patch as an attachment is fine.
> 
> James
> 
> NrybXǧv^)޺{.n+{"{ayʇڙ,j fhzwj:+vwjm zZ+ݢj"!
> 
> ______________________________________________________________________
> This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
> 
> Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
> 
> Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
> The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
> ______________________________________________________________________
> 
> 
> <libsas_t2t.patch>
