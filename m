Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1EQE0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 00:26:49 -0400
Received: from smtp2.mail.ru ([94.100.176.130]:37860 "EHLO smtp2.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007Ab1EQE0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 00:26:48 -0400
Date: Tue, 17 May 2011 08:26:44 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        Eric Miao <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        Harald Welte <laforge@gnumonks.org>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH v2 1/3] ASoC: Asahi Kasei AK4641 codec driver
Message-ID: <20110517042644.GA19254@rainbow>
References: <1305579805-15617-1-git-send-email-mad_soft@inbox.ru>
 <1305579805-15617-2-git-send-email-mad_soft@inbox.ru>
 <20110516212533.GA2570@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516212533.GA2570@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:25 Mon 16 May     , Mark Brown wrote:
> On Tue, May 17, 2011 at 01:03:23AM +0400, Dmitry Artamonow wrote:
> > A driver for the AK4641 codec used in iPAQ hx4700 and Glofiish M800
> > among others.
> 
> This looks pretty good - a few small issues realting to the use of old
> APIs and coding standards below but nothing serious.
> 

Hi, Mark! Thanks for review - your comments are really valuable.
It seems that ASoC APIs change faster than I adapt this driver to them, but
I hope that preparing v3 will take less time than v1->v2 took :)

-- 
Best regards,
Dmitry "MAD" Artamonow

