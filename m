Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0HZQWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:22:07 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:32340 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754233Ab0HZQWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:22:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 424663.49348.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=5yG+/EUmOC3XhvKPlE16+2/CDo3bFY+QBncdsf6ErqHhj2E4kAFRY9/zM8ls5VCxzYWL1NMYk+EaGGRvLZyetOcjdxQcMYW5uRmkUpP4GYG7/wHs85/g3rhMpJq/zZ4aS/GYWILYAf8E18UODcZCYC/EnwImdSWqqlx3nqqJ7Jg=;
Message-ID: <290252.99759.qm@web180316.mail.gq1.yahoo.com>
X-YMail-OSG: Y3dXoZAVM1kWiOQifal7rEZ4LNV8P5cQklM6KJZSRDvNDxd
 MlhkthGnJREexA2bs0fJPZaHGXFvsdaUvCe4ezczsHQPjxBF5LuPSZnvS18z
 mgzLKUUdqbwtaMbTTILax.kFEywl2Sr8z_yVW4Uifk8evz_Tr_QZ4SvFPEdP
 XmYoqh90FtveaRiqb36cOaiw9Bj36wsLRpwVzZW_AHfKuOwdIp05oASDlfcg
 dp7HEOwjwIPZVYD0ZJPZZGIpcM90sfpud676XSnfSwnfoDqTu8MirNgn1dqA
 SDJeedwJZOfk_ZZbBUcCMgfP3KHxXggkJJOgxiYI-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Thu, 26 Aug 2010 09:22:05 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] gpio: Add generic driver for simple memory mapped controllers
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100826051705.GA25521@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If you don't like the word 'generic' in the
 email subject

Or patch description.  It's neither
generic (IP-block-specific) nor simple.


 I can remove it,
> but I don't see why the name 'simple'
> doesn't work for > this driver.

It's not simple; I've seen far simpler GPIO
controllers.

Just rename it to match the IP block used.
That removes all confusion.  Engineers will
 be able to know more easily whether this
driver is even relevant to them.

An example might be "amba-9999 (a made-up
number, likely not matching a GPIO controller).
DesignWare drivers tend to use dw_* prefixes.

- Dave
 

