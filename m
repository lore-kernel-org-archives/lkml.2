Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0JYQOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:14:55 -0400
Received: from web37605.mail.mud.yahoo.com ([209.191.87.88]:41691 "HELO
	web37605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755496Ab0JYQOy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:14:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=BGot9hp2sq25dnK6N4QvsyBiDSy2ZbD+ur2sJnmDsrRgulhrsk/S40uao7R6TXsQQOFho+OEooBYe4lwN1N3B5J6g5i1Z6sAbYhEWrro9kDBMhrn+39aXmJ1Fh4iOkBG0D8ONjh10UpwdDAt4kh60ccrNC2rWXEQc4uFBVShb3s=;
Message-ID: <631595.20689.qm@web37605.mail.mud.yahoo.com>
X-YMail-OSG: uciD068VM1mr043np1GMXFYCrGf8OS.5GCj.1qr18IsQmB1
 Bj6J9FDs9Jz_l8eEn8Qebcr0eWdfki2d2O7yYlAmVSo0SK7pLdqx_qhguKB1
 1QdLizBj3xJ9lcevMOUCupSiOTt0CaL.6Cn_pXFgVElwF1lpxzDPPAwMYmjG
 hYw3_rS2R2BDKUBRxpmnQn5xH.iOluGvOlB0Gfrt4BwWk8ezCpM4LBgwNOPE
 5HDCCUSlmZsuySXktOec8TZRSaebmRwtqzBDBzWYQlCkgiRtRDBqpMkxIaQ2
 pc2B2aJjdSgg4q8aVxB9ycrxTKoSlCXgGryDanTxtug4O1UfXfaGk9DdvwAa
 aM8Vg8GWGB5UGjaqvl1AvCcjw3DHZiSVZX7hNGMIspaz5V84e
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 09:14:51 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 24/29] memstick: jmb38x_ms: rework processing of the TPC one after another.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Maxim Levitsky <maxim-levitsky@gmail.com>
In-Reply-To: <1287791637-10329-25-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 24/29] memstick: jmb38x_ms: rework processing of the TPC one after another.
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>, "Maxim Levitsky" <maxim-levitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Lift some common code.
> Also make sure new TPC is always exacuted from a tasklet.
> While this decreases IO speed a bit, this makes sure
> we won't have large latency.
> 
> Signed-off-by: Maxim Levitsky <maxim-levitsky@gmail.com>
> ---

Probably a good idea.



      
