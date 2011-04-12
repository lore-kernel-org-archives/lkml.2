Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1DLTmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:42:50 -0400
Received: from void.printf.net ([89.145.121.20]:49245 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589Ab1DLTmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:42:49 -0400
From: Chris Ball <cjb@laptop.org>
To: Cyril Hrubis <metan@ucw.cz>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org, marek.vasut@gmail.com,
        linux-mmc@vger.kernel.org
Subject: Re: zaurus: mmcblk0: error -110
References: <20110412151547.GC20815@atrey.karlin.mff.cuni.cz>
	<m3aafvz30t.fsf@pullcord.laptop.org>
	<20110412193944.GC2665@atrey.karlin.mff.cuni.cz>
Date: Tue, 12 Apr 2011 15:47:34 -0400
In-Reply-To: <20110412193944.GC2665@atrey.karlin.mff.cuni.cz> (Cyril Hrubis's
	message of "Tue, 12 Apr 2011 21:39:44 +0200")
Message-ID: <m3oc4bxne1.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 12 2011, Cyril Hrubis wrote:
>> Your symptoms match the bug that was fixed by:
>> 
>> bad3babace2ee4d ("mmc: fix CONFIG_MMC_UNSAFE_RESUME regression")
>> 
>> but this fix made it into 2.6.38, so if you're using 2.6.38 final then
>> you shouldn't be seeing this.  Could you confirm that you have this
>> patch?
>
> It seems that the pxa tree I have is still based on 2.6.38-rc8.
>
> And yes, turning CONFIG_MMC_UNSAFE_RESUME off seems to fix that problem.
>
> I'll try to update the kernel tree and try again with CONFIG_MMC_UNSAFE_RESUME
> enabled.

Okay, great.  It was introduced in 2.6.38-rc1 and fixed in 2.6.38 final.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
