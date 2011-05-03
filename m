Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1ECUZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:25:22 -0400
Received: from nm10.bullet.mail.ird.yahoo.com ([77.238.189.39]:21155 "HELO
	nm10.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754756Ab1ECUZV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:25:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 535928.93592.bm@omp1005.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=QX/G3TBvEjcjjZWlJ6UNBYQb8jD4ELho6ZCv7VF6JfEVwQ0yvHt0W06u8fOu8dxGEyIQne5yb2oyc41VdGo1REpzvbbU00VO3W+cF7hP8V3AJcpt6U91Mj50rl1ZYcYeZLon3Y7Vnhud9Q2i2+bYJfmjjW+Dwhk/bzn81roip+A=;
Message-ID: <430965.32751.qm@web29011.mail.ird.yahoo.com>
X-YMail-OSG: RT6K6ooVM1n2fLIRiWDjS7a997vus8VxFDm9q6Qtjvmy7cK
 acocJ.ESg5WvvkrcWV2AY8_Q1oFY4MzYdv1yiGQ1SnKxQz2qP_xSZGzVWtz5
 2EAMu62mC_HukNakNYeuHfd1mg6fSrFtbsAUzGFxxkz2qfud5rcF_CVXuLux
 4LdSxw08NjNPnrR_oemoDR4205pRD4tf4Xbq625Ixzq8adLCay3N2bIfJdnM
 2DhCr8BIE5nrQzCQyw985dRjoZxVgjAbfMnejKspLsiFm6Zbou.RuK.yElB1
 L20sO1eoCPM1ixc7kSq4GZm9EFN9jtowdvx7z4Sl.qvZwhqxGtKv91rduNw-
 -
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Tue, 3 May 2011 21:25:19 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 2/2] leds: Add ASIC3 LED support
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, rpurdie@rpsys.net
In-Reply-To: <1304421107.15687.15.camel@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

--- On Tue, 3/5/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:

> About this, see the other patch I sent. This should work
> with the GPIOs
> configured as outputs.
See my response on the other thread.

> I'd just use DIV_ROUND_CLOSEST((ms)*1024, 32000) here.
Will change.

> Could be moved into struct resource definitions in
> asic3.c.
> Get to them with platform_get_resource() in
> asic3_led_probe().
> After calculating the bus shift from the resource size, you
> have
> everything you need to get rid of the
> asic3_write_register() export.
I understand, but my feeling is that implementing a more generic mechanism will add complexity for little obvious gain. If the LED driver ever needs to be more generic then this can be revisited.

> Why not just return mfd_cell_disable(pdev);?
It wasn't always at the end of the function as it is now! Will change.

Regards,
Paul
