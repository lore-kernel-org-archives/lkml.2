Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab1IOPFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 11:05:32 -0400
Received: from nm24-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.226]:41460 "HELO
	nm24-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933899Ab1IOPFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 11:05:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 146470.36646.bm@omp1028.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=ek3fiTV1S6K7CS6pZTgvLJbPc5TtYP4bUx+gdKl9vjKKHqxcd+pF07xf61Tt55chX0hTwz2euliuESMSuLMR7EY2NE/W6cUt8kUpsj2KU/vTFgSeCzj9R9GdcNwHfBhjwvTMT+jZQpwN+0TDnyGtRNDwfs7gjEp9FslDM5msX6U=;
X-YMail-OSG: Xm71Pt8VM1n7SfarIR9c7Hbs8i6VAh2qSDXYBUkDLecfPAn
 Wit4U.dr2t4tOVgad.RZkUu1IEKZalwMK4of.X2iOl8K7lMh4Sv_GKwcwMLm
 mmnf1oADTmfKEEfCdfqC5Qf_h72KM8_0cWnuIVz41o.LN4cVnFVEr13UKS7L
 iL8LV3mSd_kXVStLASeBrkcF8mqZhj7wrjnF1oMx1dXr90GzPeK_njGNE2g8
 jwmKnjdNSRSmnV2ZQ0fFuh.B0yCIxUWaPmfIgo_cgpZoRAvK51WyUL7q9B_d
 Xpj0xMfunQnQPYiQPw5CFoGa8jDwnvVQkfAknnj8rgfegSAc.rZr_dEuC8lz
 XzzzHp3QHliCUF8tdsQvWjIdBx30r2quDdBqXgg_MRxgyw8pr1yRk5oXiA8m
 TMFfUJUi6LCLrkWEgWQsLtwxmsZ3LcomazQXQL4iPyue8CqrNyPJEb17eD0r
 R08gaz_hThwk_Liqu75rv9KmeFP6TaPJSOWbazoIKKVs.WgZ_Kz8yL.80TFr
 aSGavI.0rZrXJKJpfyb5SyhYZp6.uUhaedEbpMAGG1kGfOsIzZaS7J8tj503
 71wduwThAiRAWjLqhP_c-
X-Mailer: YahooMailWebService/0.8.113.315625
Message-ID: <1316099130.7561.YahooMailNeo@web114311.mail.gq1.yahoo.com>
Date: Thu, 15 Sep 2011 08:05:30 -0700 (PDT)
From: Justin Mattock <justinmattock@yahoo.com>
Reply-To: Justin Mattock <justinmattock@yahoo.com>
Subject: general protection fault: 0000 -#1] SMP
To: "refpolicy@oss.tresys.com" <refpolicy@oss1.tresys.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



using the current mainline, I woke the machine up from suspend, then started to relabel the filesystem, using the stable release policy(MCS). then this showed up:
I only have photos of the crash, due to a total system lock
http://www.flickr.com/photos/44066293@N08/6149812345/in/photostream
http://www.flickr.com/photos/44066293@N08/6149811913/in/photostream

Note: I subscribed using my yahoo accnt due to changing, but for some reason, am not able to complete the process
(will try again to see).

if you need more info let me know(I will try and recreate this, and possibly due a bisect on the kernel and/or pull refpolicy git to see)

Justin P. Mattock

