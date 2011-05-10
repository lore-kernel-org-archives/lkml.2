Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab1EJJhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:37:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41872 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab1EJJhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:37:51 -0400
Subject: Re: [PATCH] regulator: Move VCOINCELL to be the last element of
 mc13892_regulators array
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <BANLkTintTfzPnYuUtvJuEoAnmjf4_=K=KQ@mail.gmail.com>
References: <1304609578.5296.4.camel@phoenix>
	 <1304953437.3192.13.camel@odin>
	 <BANLkTintTfzPnYuUtvJuEoAnmjf4_=K=KQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 10:37:47 +0100
Message-ID: <1305020267.3206.14.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-10 at 16:54 +0800, Axel Lin wrote:
> hi Liam,
> 
> > Applied, Btw is this fix also for 2.6.39 ?
> 
> I check this patch again and found this actually is not a bug
> because MC13xxx_DEFINE explictly defines the order of each entry in the array.
> 

:(

I've already pushed this into next, can you send a fix asap.

Thanks

Liam

