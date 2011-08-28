Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab1H1Qsz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 12:48:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33242 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1H1Qss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 12:48:48 -0400
Subject: Re: [PATCH v2] regulator: tps65023: Remove num_voltages array
From: Liam Girdwood <lrg@kernel.org>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <CAF+7xWmOKm4iDFMm8hp6Aa=L3+XBSqu-K-_RHE5ZH_aMQzk4qw@mail.gmail.com>
References: <1312277900.2191.1.camel@phoenix>
	 <CAF+7xWmOKm4iDFMm8hp6Aa=L3+XBSqu-K-_RHE5ZH_aMQzk4qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 28 Aug 2011 17:48:43 +0100
Message-ID: <1314550123.3666.5.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, 2011-08-11 at 07:16 +0800, Axel Lin wrote:
> 2011/8/2 Axel Lin <axel.lin@gmail.com>:
> > We can get n_voltages for each regulator from table_len of struct tps_info.
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> 
> hi Liam,
> Seems this one is also missing.
> 

I'm just back online from a two week broadband outage and working
through backlog now. Any chance you could resend these 3 with Acks.

Thanks

Liam 

