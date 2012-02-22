Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2BVIkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:40:45 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50923 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab2BVIko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:40:44 -0500
MIME-Version: 1.0
In-Reply-To: <20120222003747.GA9808@gamma.logic.tuwien.ac.at>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	<CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	<20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	<CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	<20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	<CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	<CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	<20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	<20120127015015.GA23291@gamma.logic.tuwien.ac.at>
	<CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com>
	<20120222003747.GA9808@gamma.logic.tuwien.ac.at>
Date: Wed, 22 Feb 2012 10:40:43 +0200
X-Google-Sender-Auth: xKcOParOacS14cjZZMZMRuA2PmY
Message-ID: <CAOJsxLENnvYn+xkDufQeTcgbKBsrrf=hw=g_ejCrts7ZNPa-Cg@mail.gmail.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: Pekka Enberg <penberg@kernel.org>
To: Norbert Preining <preining@logic.at>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>, linux-kernel@vger.kernel.org,
        ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 2:37 AM, Norbert Preining <preining@logic.at> wrote:
> I still see that, on 3.3-rc4, and it is the same as usual. The interface
> believes it is up and connected, but nothing works.
>
> I am *100%* sure that this is related to the driver, because in old
> revisions (somewhen around 2.6.27 or so) it was working without
> any problem, and when it started I reported it long time ago.

It's definitely a kernel regression, no question about it. Was 3.3-rc1
already broken for you? It shouldn't be that difficult to find the
offending commit with git bisect if it's that easy to reproduce for
you.

                        Pekka
