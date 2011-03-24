Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab1CXD2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 23:28:01 -0400
Received: from web37606.mail.mud.yahoo.com ([209.191.87.89]:24026 "HELO
	web37606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932865Ab1CXD2A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 23:28:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=5w29sxhngk9xMKO0sChaWGrw1fVIYUVT+Tsiy1/A4Q0KM2CvAXbZK4LHUjkYlyaFYbrcalGmQQlGpJyGrUBTSCszah7xP/clEVuUxonOWYQ6e5Yg21l/zssbFFLScBTgx4K2gTTOTU/T9Dc+EN/6qZluAXpVDNWjd6P4yDyeIQA=;
Message-ID: <20244.46628.qm@web37606.mail.mud.yahoo.com>
X-YMail-OSG: bQij2pAVM1nCoCLER66o3rSHq_C9ixJKFkzPaXDNiJLpiZp
 UOroHhHgnXqaZuIWbc39f0I03QLJlj.fNv_zQ2CryLtYkkoi.nhi4lv0EL8j
 KKKjanx1B9OlggvzSu7N_34F_GfirJ.zSFG8fqyhYtLauyNIn.t4lkj_uYlP
 2WZVh1MjZlNmfKQjlmBTFLVj33mvfEG_RQOpw2c_XE7csl5PrcsOpZ42kqEV
 wWpre_l1ySnob9bxWYnvynn_P4q4FS8zAhBbwo3TkOPQapa..VBbqaYGZ4ug
 BVUnFDh7SncVTnMgh.eSV97KStmtyq2JO4DTNTvEsVsCIVb8N4nxN5CA4AoN
 O_tmNHdcnYoMriB.7F.Kk0Hr5TjrZ0kl_NzNk7Me4CJysLa472UNQWJzQYI0
 ZMfsQFlYLYMmE
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Wed, 23 Mar 2011 20:27:58 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATH 0/4] Memstick patches for 2.6.39
To: Greg KH <greg@kroah.com>, Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1300894239.5791.15.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 24/3/11, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > > 
> > > 1. Please merge r592.c, it doesn't depend on
> anything.
> > 
> > What type of driver is that?
> A driver for card reader that reads Memstick cards.
> Two such drivers from Alex Dubov were already merged.

I would like to point out that the discussion is not about r592.
We all agreed, quite some time ago, that it can be merged and were you,
Maxim, submitted it separately 4 month ago as per my advice it would be
in the tree already.



      
