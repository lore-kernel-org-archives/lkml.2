Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0HWQgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 12:36:37 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:21122 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751273Ab0HWQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 12:36:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 134347.85489.bm@omp129.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=PyaqCOXkAMGp3E1B+0+BEaVfJ0bx8dnJvp9YY1Nzac/odtd83GAab1aPzcIC7UTltII2qQq+xfHGbCwKs65VJVfFWCfSwlrHbU14GhrZh4eLRA7Tc8+s0yocKz5pqq9gDWhRfLozvSU9ArEHk3d3r2zeKAbH4e4jAXi3z+6LcnE=;
Message-ID: <30193.50267.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: KKg6pNUVM1ktudlKFvn2ib41n.ge4DaJxRnOI4DcJXmFgev
 XvZNBAllG_SD1wz449jUXRw3ndSsVHFhzbSSPZqWk4eusfM_Dsw.R7bamjHx
 NxDlfwKip.QcEvHMmanTR6.JiSbkzUwc1AvQ8UC_dla9MrxhTwMgqO4o2fdL
 1RS_cqqUHj6dB4n.VRVv6K1a4X1itxb_YHYzU4XS_MN1.mXwtDrfy0q1JqpU
 eHdhCUpi90wjl.NsjXFHQ9kFaPT0TAaGpq0doDB8sCtw5lsJ3YVehszuaSsl
 0WdRk8fggAczn7teX32z8wVPz8baac3zn99qvIk6j.VztLWr.JXyIJjO_XZu
 oAekYr2wAuyOW
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Mon, 23 Aug 2010 09:36:34 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] pio: add arch specific gpio_is_valid() function
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bn@niasdigital.com, ryan@bluewatersys.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: avictor.za@gmail.com, Nicolas Ferre <nicolas.ferre@atmel.com>
In-Reply-To: <1282575669-24501-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Mon, 8/23/10, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Subject: [PATCH] pio: add arch specific gpio_is_valid() function

What's the rationale?  It's valid or not.  And there's already a
function whose job it is to report that status ... which is set up
for arch customization.  Which ISTR worked fine for AT91 (among other
platforms) ...

So my first reacion is "NAK, pointless".

> 

