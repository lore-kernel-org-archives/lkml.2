Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1HJPTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:19:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42018 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1HJPTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:19:21 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1311955847.2712.12.camel@CNA0741383>
References: <1309995504.2496.1.camel@phoenix> <CAF+7xW=AXA9RgddR0HgFwWdRcy6v1hcDXc7Z7KXb1DTBuzH-Pg@mail.gmail.com>
 <1311955847.2712.12.camel@CNA0741383>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 10 Aug 2011 23:19:00 +0800
Message-ID: <CAF+7xWkUO0d7Bp4a8-0cksZhhcQ-jb4XfRCEP=qCqb3_qb5RxQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 RESEND] regulator: aat2870: Fix the logic of checking
 if no id is matched in aat2870_get_regulator
To: Liam Girdwood <lrg@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jin Park <jinyoungp@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/30 Liam Girdwood <lrg@ti.com>:
> On Fri, 2011-07-29 at 18:05 +0200, Axel Lin wrote:
>> hi,
>> Seems this 2 patches are not upstream. Should I resend it again?
>> Regards,
>> Axel
>
> Not required atm thanks, this driver went via mfd so I can apply the fix
> after the mfd merge or rc1.
hi Liam,
aat2870-regulator.c is already merged to your tree but
seems these 2 patches are not (yet) upstream.

Regards,
Axel
