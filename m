Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab0JTO20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 10:28:26 -0400
Received: from nm3-vm0.bullet.mail.sp2.yahoo.com ([98.139.90.230]:26740 "HELO
	nm3-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753134Ab0JTO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 10:28:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 750745.38020.bm@omp1021.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=xQbKjRBhhDNavABd9TLmamcNulmBhUD3k8rI6HStADZP5RH/kGIWcJn1FlKuKE6gx0wTBUUhJKX7t9+Pa2qodiwXXqzR3QiST5wNn8SjgW6h6inQytQ0O7CVF4TzT+xjLgnaMuTUpDygTpYSh4d2D+vpU4QV+prMnE36+9gu62M=;
Message-ID: <298571.53927.qm@web180308.mail.gq1.yahoo.com>
X-YMail-OSG: N.8.e8kVM1lBz6K2mbS8mInvrBirluZiw9AG6BJC6GuDDY1
 sUGLEb8csslcGYUS.vsgQ2btfBu2NYStEUbVyz5yA6bng8tZ.yVngFxDYyPd
 t0Lpqek02F.7d.Pns6UozgHJRB80YO8meNj4dK5pKVyTOwvcxmOUxQ20zLTd
 qvpqZoKzqzYEF_y7u3ep8UBlsYBufxXG1BzGQgV_3cSm6P3hcmyAfqJsHYFB
 s.s674wY1QFDVpo9PtkZZBUCxGGW2glMew.wWg0PadtBrPKPRVS0z4EOZ.np
 tQc8BCWCqJ9rJNdXUP_U-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.106.282862
Date: Wed, 20 Oct 2010 07:28:23 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out 8-bit shift register
To: Florian Fainelli <florian@openwrt.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
In-Reply-To: <AANLkTik+kyXcPDTx50K1k0T37cuaWh=Ghv7ut=F_1U2X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just for the record ... spamming my mailbox
with dozens of copies of a patch is a very bad
way to get me to allocate scarce review time.
Please reconsider your strategy, and switch to
one which doesn't try to waste so much of
the patch recipients' time.

