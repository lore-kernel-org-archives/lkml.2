Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0GBAVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:21:06 -0400
Received: from bwv190.internetdsl.tpnet.pl ([83.18.229.190]:36834 "EHLO
	bwv190.internetdsl.tpnet.pl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab0GBAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:21:05 -0400
X-Greylist: delayed 1622 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 20:21:04 EDT
Date: Fri, 2 Jul 2010 01:51:03 +0200 (CEST)
From: Piotr Gluszenia Slawinski <curious@bwv190.internetdsl.tpnet.pl>
To: Dave Airlie <airlied@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
 kernel  component
In-Reply-To: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1007020143560.9535@bwv190.internetdsl.tpnet.pl>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are going to start to see a number of companies in the embedded
> space submitting 3D drivers for mobile devices to the kernel. I'd like
> to clarify my position once so they don't all come asking the same
> questions.

one of options for future would be equipping gpu's with additional
processing force, allowing it to run whole Xorg on it's own,
and just communicate with rest of machine via shared memory window (so 
visible as 'hardware X server' from systems standpoint),

option which allows both - closing 'source' of gpu , and taking
off burden of development for closed, once-use-throwaway
devices from Xorg and kenel crew.

also port of Xorg on GPUs itself allows skipping a lot of features
of kernel, and OS itself (it doesn't to be based on linux afterall)
allowing much more robust performance, and skipping common bottlenecks
(sharing irq's , scheduling, etc)

but this route needs to be considered by hardware vendors themselves.

--

