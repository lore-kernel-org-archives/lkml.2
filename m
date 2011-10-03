Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1JCFFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 01:05:39 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:59428 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310Ab1JCFFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 01:05:32 -0400
Message-ID: <4E894295.5000608@ti.com>
Date: Mon, 03 Oct 2011 10:35:25 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] ARM/omap: omap specific randconfig fixes
References: <1317566760-25681-1-git-send-email-arnd@arndb.de>
In-Reply-To: <1317566760-25681-1-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

On Sunday 02 October 2011 08:15 PM, Arnd Bergmann wrote:
> Hi Tony,
> 
> I've mentioned these patches before, and now I've managed to
> go through them again and clean them enough for submission.
> 
> If nobody has any objections, I would like to send them to
> Linus in the coming merge window, otherwise it would be nice
> if you could pick the ones that look good to you and send
> me a pull request. If any of these look like they should be
> backported to stable kernels, please tell me and I'll add
> a cc:stable@k.o tag.
> 
> The entire set is also available from
>  git pull git://git.linaro.org/people/arnd/arm-soc.git randconfig/omap
> 
> but I have not yet pulled them into the for-next branch.
> 
Do you have any scripts to create these randconfigs ?
These are useful to run on newer set of patches also to get all
builds right first place.

Regards
Santosh
