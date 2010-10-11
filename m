Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0JKGQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 02:16:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38812 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab0JKGQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 02:16:24 -0400
Date: Mon, 11 Oct 2010 08:16:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: maciej.rutecki@gmail.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is this? Should I worry?
Message-ID: <20101011061618.GA4899@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Piotr Hosowicz <piotr@hosowicz.com>, maciej.rutecki@gmail.com,
	LKML <linux-kernel@vger.kernel.org>
References: <4CAFEFF1.8010202@example.com>
 <201010102039.31706.maciej.rutecki@gmail.com>
 <4CB20CED.8060403@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4CB20CED.8060403@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Piotr Hosowicz <piotr@hosowicz.com>
Date: Sun, Oct 10, 2010 at 08:58:53PM +0200

> On 10.10.2010 20:39, Maciej Rutecki wrote:
> 
> >Can you check clean kernel (without any proprietary module)? That. 2.6.35
> >works fine (it's a regression)?
> 
> I build and boot every published kernel and this was the first time
> I saw this error. I have NVidia graphics and use their driver.

and this time, test the kernel without the nvidia module - use a free
driver instead to rule out the possibility that the nvidia driver is the
culprit.

Thanks.

-- 
Regards/Gruss,
    Boris.
