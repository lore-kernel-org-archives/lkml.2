Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0HZW6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:58:54 -0400
Received: from n2-vm0.bullet.mail.gq1.yahoo.com ([67.195.23.154]:39437 "HELO
	n2-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751887Ab0HZW6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:58:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 856856.29985.bm@omp205.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=GTDBNDTdAjanaPIWsEqq/UpXeqLbaLWAcl1fhaa6RbR5cPAkHAUOIaYVqHW03WxYEoQhvhPzLcdH2dM/Av9AuY6j2UcsM/mShdeOyL6o5MvjpcP2Y8sT3f2WTPTTUoXOVRKbWkKw6mLcl4JkIj/piANMSC29NuggmtjTEDGt94o=;
Message-ID: <611842.81625.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: R6Hb3qoVM1mcBbK47E3hRhNfuNV1ABR7noZX.0slZDuiHpt
 AkSnLbk.Z
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 26 Aug 2010 15:58:51 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped controllers
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100826220747.6da28e97@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Thu, 8/26/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
 (Which calls
> into addition.
> 
> I think you need a reality check.

I know you don't say that every time someone makes
different assumptions about context than you have.
So for now I guess I'll just feel special...

And I expect you'd have to admit that if indeed there
were some IP reuse happening, then everything I said
which assumed reuse would be true.  Likewise, that
such reuse does happen even for simple stuff like
GPIOs (to facilitate reuse of program code ... even
on  the 8-bit micros you mentioned, I've seen it).

