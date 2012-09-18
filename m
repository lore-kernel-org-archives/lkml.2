Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422Ab2IRHby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 03:31:54 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47148 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2IRHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 03:31:53 -0400
Message-ID: <50582394.8030606@ti.com>
Date: Tue, 18 Sep 2012 10:32:36 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120917 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl: Move PWM driver to PWM framework
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de> <5044664C.5010508@ti.com> <20120907131926.GF29340@avionic-0098.mockup.avionic-design.de> <5049FC05.6090101@ti.com> <20120918070752.GA17545@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120918070752.GA17545@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2012 10:07 AM, Thierry Reding wrote:
> Peter: does this Acked-by also apply to patch 1?

Just sent my ack to the first patch.

> Do I need Acked-by's from anybody else? I was hoping Samuel would give
> his, but there has been no response for over a week. Does anybody know
> if he's on vacation or so? I thought I had seen other mails from him,
> so maybe he just overlooked this. Before I queue this up for Linus I
> wanted to take it through linux-next for a few weeks, but time is
> already running short.

Yeah, this reminds me that I also need to ping Samuel for several series
waiting for his ack or to pick them up.

-- 
Péter
