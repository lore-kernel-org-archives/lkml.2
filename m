Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab1EBWXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:23:02 -0400
Received: from nm13-vm0.bullet.mail.ird.yahoo.com ([77.238.189.195]:31696 "HELO
	nm13-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756982Ab1EBWXB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:23:01 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 May 2011 18:23:00 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 442421.16700.bm@omp1008.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=bfWu47QAAvowpwYPZlXtCF2Bu4/l5yeg8ofAEMD69SZWIu2nonXqQq0TqkxSt377JLXJUUaQpnSbtk81+rZcABFe2IrtMxJdaXrQkmaLTbqqp5SHLkpDicTb9BavJiotgJKFyYugNn4mb39iBwFF6gVA+HqR+1zQaLe8j0+KT9c=;
Message-ID: <325376.71935.qm@web29015.mail.ird.yahoo.com>
X-YMail-OSG: 5dFYTxAVM1k_C_N3w12hxjb8.tFJiOV3s3L7FDSG7YtPGWv
 oVGSGG2EAKNg9_wX89OZfcqu3rWlBYn9Hj878ic24tl62uI3z4WmUlHHQTZ4
 pOEQrLjrXUfgJXSAv80Upw4rpXOaXC65bkmkhPoe5xPh5OMLndr8K2.zVfsy
 NzEti9GaLb2Q7dcnyJLRa1u.Jv0BFCqBqDYvE4KJTawzz3YMOUSxz1cLueI4
 89rum20oyOyjoX8YlfBg3VgLvDT35X8ajEojN_5AIZ5gfkgWlARPQebnJlcx
 GeAkS6pbvdu61aUXHk82OeWVeVIkfX7U7Oqp1Bns5teJPcy9t__nnskR6.g-
 -
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Mon, 2 May 2011 23:16:23 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110502153951.GH8222@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

--- On Mon, 2/5/11, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Where is the LED driver ?
It was posted separately - [PATCH 2/2] leds: Add ASIC3 LED support - since drivers/mfd and drivers/leds are maintained separately. Sorry, I should have cross copied them.

> > -static int asic3_clk_enable(struct asic3 *asic,
> struct asic3_clk *clk)
> > +static void asic3_clk_enable(struct asic3 *asic,
> struct asic3_clk *clk)
> Although a valid change, this is unrelated to this patch.
Not completely unrelated; I call asic3_clk_enable() and found it simpler to remove the unnecessary return value rather than check it.

> > +    asic->gpio.label = "asic3";
> Ditto.
Agreed; that was left in by mistake.

Should I resubmit?

Regards,
Paul
