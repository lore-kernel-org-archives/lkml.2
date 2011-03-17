Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1CQGlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 02:41:16 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:46215 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751589Ab1CQGlN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 02:41:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=h+MiKvej6O/0+ef/E9LKv558U/HdrdLdjbvMsYQkA9KN2QWp6tavK7ACDPpS68ySsC++hAKQaFBi3T/JTISuPpyKlsfH3+oDXkSUoJbnbU0ra6HKYY7e0t1BygxucdwgVD5HuVmb2H0KGTf9vUzCsnZEFDzJEnFwrH9ouFmB/+Y=;
Message-ID: <158286.40597.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: eWuoqAkVM1mtN6qYATPQgjCMCm2hnRgvEmKyB3Gq7_dzuCE
 1z61f9za3IxK_K1LVl8EEDFD6o546EIyOgmAf8L6L7.QXD40R00G_g9pTKwr
 VqvHnBUtQkujxypKYqs.XTWSqoR_4Na9aremi6Qk_OGU7sIB6yO_vsYHNL9G
 gdSPoBnyFwTZ8J.2Da6HmG3ERAb0htz9AjXOBuf4JZxhD4_YJ56HxjdPSMWt
 d.C9ZcGLZcVNxCK5DiZ31q4G8S9ZTLIdbekjC3lFE7jd6p7Z5jlEL6XaJgXg
 SqMO05ZdB1Kd33sklqSknKc.LVgQxR7iTxIkMknybqNyx0Pd9KKUeKrDPz0j
 sc4xw
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Wed, 16 Mar 2011 23:41:13 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, maximlevitsky@gmail.com,
        James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
In-Reply-To: <20110316153321.8345606a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Do you believe that any other driver is likely to ue the
> sg
> infrastructure which this patch adds?  Should those
> additions be 
> internal to the memstick code, at least for now?
> 

Considering the comments from Fujita and James, I suppose it will be best
for now to fold the new sg functions into the memstick patch and
investigate how the block layer functionality can be used to a greater
utility at some later time.


      
