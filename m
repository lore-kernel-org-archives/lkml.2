Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2AJSrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 13:47:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35632 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320Ab2AJSrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 13:47:42 -0500
Date: Tue, 10 Jan 2012 18:47:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] davinci: CQ93VC: remove machine specific header
	file inclusion from codec driver
Message-ID: <20120110184741.GG7164@opensource.wolfsonmicro.com>
References: <1326194863-31194-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326194863-31194-1-git-send-email-manjunath.hadli@ti.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 04:57:43PM +0530, Manjunath Hadli wrote:
> remove unnecessary inclusion of machine specific header
> file mach/dm365.h from cq93vc.c voice codec driver
> which comes in the way of platform code consolidation.

Applied but please do try to use a subject line appropriate for the
subsystem you're contributing to.
