Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0ETQW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:22:58 -0400
Received: from n20.bullet.mail.mud.yahoo.com ([68.142.206.147]:27316 "HELO
	n20.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752177Ab0ETQWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:22:55 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 378931.40721.bm@omp201.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=Xmjtmbp7EfEjxSUPa7IsPzJoJlLlL13Qh1DLqAZjCbwkSgnm2RUsTEbXoHkp3m+CbSY0EeP7ANE7IYXsHQv5gsr5gKhiHYpFVxMjqP2gecSbgjw+P9EEKhI/FWuhTZs2uZdqIS5Mx2D8aeb46uJJaafUTt2zcOhynLsRxUf0bOU=;
Message-ID: <249011.66068.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: H0MrSqMVM1lNPiaGLtwn5nf90nLu1f4IJ80W0uO4TS00VYL
 Cn7FvUGIr9f1_hxzud4uFDplvEA53eYezN2o5o9xVc979U1sujvhZX4Iofqe
 dcdPvwRnK5ePi9JO_0ToNRU16.fuMaL9hHiAwAoZMLMnYCumf1omCFU6NIdR
 uW1JKzDHe7wmXWeJdRIG8P5lzXElamuoLpWqNE0K0pyf65FIQpgOXLs1E0Qf
 EtTvncNsdGDQC9rTWxHmsijvUkcNOk6L080O85IAErNgrf0zCp4qL3RjviZu
 SCUJ_KsR2QImjWgT_Ng--
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Thu, 20 May 2010 09:22:54 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH 7/8] USB: gadget: g_multi: more configurable
To: linux-usb@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <2460ac80ee51e759c7d4d552112c2e816db7c83b.1274187425.git.m.nazarewicz@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Added Kconfig options for each
> function used by g_multi so that
> one can customize the gadget to a greater extend.
> 
> Note that it will be wise to change vendor and product ID

For the record .... I would *MUCH* rather see new gadgets than
pursue this path of tweaking/customizing existing ones and thus
removing/changing behaviors folk may rely on.

Tweaking is OK during certain development stages, but when it comes
to production, there should be a single version of the gadget driver
which isn't especially dependant on Kconfig options.  It should act the
same at all times.

