Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab2JUH3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 03:29:30 -0400
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:38312 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2JUH33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 03:29:29 -0400
X-Greylist: delayed 1366 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Oct 2012 03:29:29 EDT
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aml+ACieg1BV5h1yPGdsb2JhbABFhSsihQG1OgSBAhkBAQEBODSCIAEBBTocIxAIAw4GBC4UJQoaE4gIulAUi0s5hVZgA5VwhXSNN4FYIw
X-IronPort-AV: E=Sophos;i="4.80,625,1344204000"; 
   d="scan'208";a="214445548"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 21 Oct 2012 09:10:24 +0200
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@gmail.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] nouveau: Severe screen corruption on (0xaf, nv50)
Message-ID: <20121021071024.GA731@polaris.bitmath.org>
References: <20121018095809.GA336@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018095809.GA336@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:58:09AM +0200, Henrik Rydberg wrote:
> Hi Ben,
> 
> 3.7-rc1 messed up the screen on my MacBookAir3,1 (nv50, 0xaf) pretty
> badly. Not surprisingly,
> 
> commit 3863c9bc887e9638a9d905d55f6038641ece78d6
> Author: Ben Skeggs <bskeggs@redhat.com>
> Date:   Sat Jul 14 19:09:17 2012 +1000
> 
>     drm/nouveau/instmem: completely new implementation, as a subdev module
> 
> is the first bad commit. Standing on that commit, booting and then
> starting X yields the output below. Hints are especially appreciated,
> considering the patch is almost 8000 lines.

Going through one suspend/resume cycle makes the corruption go away,
and there are no more errors in dmesg. Oddly enough, I have seen
something very similar when using i915 on the MBP10. Builtin modules
and systemd in both cases. Maybe this is a general drm issue. Any
thoughts?

Thanks,
Henrik
