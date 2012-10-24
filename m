Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935548Ab2JXUfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 16:35:51 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:33534 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934209Ab2JXUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 16:35:49 -0400
Message-ID: <5088510B.7010400@xenotime.net>
Date: Wed, 24 Oct 2012 13:35:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Love <rlove@rlove.org>, linux-kbuild@vger.kernel.org
Subject: Re: [Q] CONFIG_INOTIFY_USER doesn't get enabled upon defconfig
References: <Pine.LNX.4.64.1210241057590.31768@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210241057590.31768@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 03:02 AM, Guennadi Liakhovetski wrote:

> Hi all
> 
> CONFIG_INOTIFY_USER is marked default "y" in fs/notify/inotify/Kconfig, 
> so, I would expect it to be enabled by any make *_defconfig. However, for 
> some reason, this doesn't happen (e.g. with mackerel_defconfig), which 
> leads to non-functional udev, among others. Any idea why this could be 
> happening?

I think it's because arch/arm/configs/mackerel_defconfig says:

# CONFIG_INOTIFY_USER is not set

-- 
~Randy
