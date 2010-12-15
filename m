Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab0LOBOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 20:14:32 -0500
Received: from web120701.mail.ne1.yahoo.com ([98.138.82.208]:36429 "HELO
	web120701.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760423Ab0LOBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 20:14:31 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Dec 2010 20:14:30 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=OYPTz7v21/duMISaXPLvKF/9cslLgD0Eszt/6X4p7mPnEgpPcHNZ3cPQkJnzt8FvxquZRzhF6b67TNTpc/KGMBhZtAl3rRLOuHlkL3x4Ly+G7I29ohz7aa+hFgWBNWyvK40YKP3RvZyxoqPu6uBfnmiiUhiOfd0kk/EcY0fzip0=;
Message-ID: <43532.6714.qm@web120701.mail.ne1.yahoo.com>
X-YMail-OSG: 7An5b4EVM1k4p2TlSmkODmp5Bv7DkkeP_2I9tbFqM__9iNO
 hwHVshY1uFkG8SxZAvG7KU6OOp8ES7h2FAA4DzHh9NleUofTvABo60FMO9pf
 iG1A5rN.aDnezN74jimLPYcHzcTiQgQs9vhqhsjkJ6RHKVwZg7DkansoTmAW
 OyRikQj_dWvqoRD2gG6ZdZrzWu2uUi0D7H9mP4s7W7KsMwvCvh6133zDatyi
 1gAmByEcJHgkWPRek9w--
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
Date: Tue, 14 Dec 2010 17:07:49 -0800 (PST)
From: Daniel Kopko <dk_fedorabugs@yahoo.com>
Subject: RE: [PATCH 1/2] sched: Fix the irqtime code to deal with u64 wraps
To: linux-kernel@vger.kernel.org
Cc: dk_fedorabugs@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the lack of quoted text and lack of In-Reply-To headers.  (I am 
replying from a webmail account in reference to the following message:  
http://marc.info/?l=linux-arm-kernel&m=129224292425624&w=2 ).  It seems that 
perhaps an unintentional omission of inline happened in this patch set, when 
converting update_rq_clock to static linkage.

 
-inline void update_rq_clock(struct rq *rq)
+static void update_rq_clock(struct rq *rq)


The rest of the functions which had static linkage added retained
the inline modifier.

This is my first message to LKML.  Can anyone recommend a decent free
email provider that will work well here?  Also, please CC me directly if 
convenient
for any replies.

Thanks,

Daniel Kopko


      
