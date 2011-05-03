Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1ECTqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:46:15 -0400
Received: from nm14-vm1.bullet.mail.ird.yahoo.com ([77.238.189.91]:24334 "HELO
	nm14-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754325Ab1ECTqO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:46:14 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 927774.19699.bm@omp1014.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PWHziF3Ic18OztGoDjtswga9kJY6BlT8F/RTADpvgJy2Jz9YdOtQFk2QiwpmjzY5k2FJ6DvG8XRj5HHf1LCbHbmAaVp4pk23Y68Ch2xn9WFBQUDxk5XpjwT0sSqX+2vXcXel8XHGXYDw0lR2txPWrDiuqocT/V461nVc+bYZFzQ=;
Message-ID: <812143.47267.qm@web29018.mail.ird.yahoo.com>
X-YMail-OSG: pu79H90VM1lKla8TFvVtUmUCCZJ4GNAQZiDPdiYoO4tFDub
 Y0UElb2PIEXWZs8Vgvn8HQ7iNIAacaZrl.WY7NokR5388viNSyM8sPA8Xa.s
 Gfqd88AAqMrljRXkCS6AJXFzbzPYe_.q9_15DbL36tO_doYNaLFlWwo6oD3A
 zJACUwoBdeKHR5a8_6FlL7C.Re_u8q1g5Jvxr8Mu6BIyGxjIxHD1L6cjKQjy
 VcwvhCgmI6t0x5pv69YqAUWbz5DWvR3H5jMX8VaB4b.ErWOfAX3vZPidOgkC
 dIGawqgCnqACBBFDi.gI9fw.Zppqb8FfxGrBNZz.PDKU0eMWQVU0DCyLpLA-
 -
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.110.299900
Date: Tue, 3 May 2011 20:46:12 +0100 (BST)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: [PATCH 1/2] mfd: Add ASIC3 LED support
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com
In-Reply-To: <1304419293.13769.13.camel@flow>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

--- On Tue, 3/5/11, Philipp Zabel <philipp.zabel@gmail.com> wrote:

> I'd like to avoid this export. Could you inform the cell
> driver of
> mapping and bus shift via io resources as it is done in
> ds1wm?
> Same for this one.

The LED registers are already mapped by the mfd driver, and the functions to access them are already provided. My feeling is that replicating all of that seems a high price to pay to avoid exporting a couple of functions.

> Ok for now, I guess. But it's unrelated to led support. And
> once we have
> a common struct clk and can use clk_enable in the led
> driver, there's
> going to be error checking anyway...
Yes, that's a separate patch if at all.

> As Samuel pointed out, better use .platform_data and
> .platform_size here
> right away.
Will do.

> Separate patch?
Separate patch.

> As I said, not convinced about that one. I'll follow up
> with a patch to
> test on top of yours.
OK.

Regards,
Paul
