Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0JYPZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:25:37 -0400
Received: from web37601.mail.mud.yahoo.com ([209.191.87.84]:33318 "HELO
	web37601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751483Ab0JYPZg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:25:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=olBPixuf8gy8Y14liGWz0I7QcSoXvhR/tK0EAYuCWVhqc/wFvzX1//PkwRR9SfLqJ1MIb+HD2zZJPjSPZPdND4oaCUahyrtMpIP/1UPF7gNd2ku4ErDA2fXfu1RaLBVXOQy2JOMHep/rprd08EGMNihsO1roYACvYpUgCqYwdck=;
Message-ID: <896041.423.qm@web37601.mail.mud.yahoo.com>
X-YMail-OSG: plxdCSUVM1mTbwiKpRcgGDt40UcDMdtKthNEWBBcxEkOSXb
 t1QswtpyyjJW6xMC8LlgjqrCb7GnoFUwoWw.3EHvLPNUANUydr.ZesEPOi.Y
 WFFMS1KdpBt_gMfaIm94tnQjpSL2WBOJ7RH7v7uFU_lP8EGBNxgN0O1OI5fm
 XlOqH9wwcHNanh2zbbyfAoc5VsSotYaT2YCiNoBHsOtZWuCaGyxzpISfPuzu
 pItVjuIg9XLTM9Gljmp4R.EUF2OyflZbPTKDWTIp3rOzcRTZj_szwNg_zrLM
 ZZSw_Q_uK4oIj88ZklnBgJehyL1ufX0LroqciI1GEu0eeldSRCgQ9MoClRlj
 3bRiaAOEkILkzXCQFFHIzKsunetXyFdqTjUJPME4qiZ9GR.iv
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:25:35 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 10/29] memstick: mspro: create _setup_io helper.
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-11-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 10/29] memstick: mspro: create _setup_io helper.
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> This function contains common parts
> of IO setup
> for the state machine, thus reduces the risk
> of using the state machine in wrong way.
> 

1. This should precede the read_attribute function patch.
2. Coding style. 



      
