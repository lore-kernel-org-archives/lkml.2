Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab1JDOo5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 10:44:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45449 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986Ab1JDOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 10:44:56 -0400
Date: Tue, 4 Oct 2011 15:44:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: ASoC: wm8994: Is the rate_reg for wm8994-aif2 correct?
Message-ID: <20111004144453.GG6934@opensource.wolfsonmicro.com>
References: <1317737239.6419.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317737239.6419.6.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 10:07:18PM +0800, Axel Lin wrote:

> While reading wm8994.c, it seems the correct rate_reg for wm8994-aif2
> should be WM8994_AIF2_RATE.
> I cannot find wm8994 datasheet, could you help checking it?

Looks good, I've applied - thanks!
