Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1BVRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:09:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62531 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1BVRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:09:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
Date: Tue, 22 Feb 2011 18:09:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
In-Reply-To: <20110222121704.19437.4650.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102221809.50716.arnd@arndb.de>
X-Provags-ID: V02:K0:tM48ukmRwQAdcSozrinkcweCeDEyGGpKRCZGPeTVAUw
 p4ADrkyaUlAyRu+tAGKpy1nkJY0ZA+ZXhiN2as+VctBKPqh5OV
 sX+VNgJSOM/n8ts+x6HA1XxVCp56zoOF5+TOUo+sd4KTyyC50W
 BA6OmreOMALk9QAhvBqkuxKB+NX0xqFx1Btu+U38C6YuzYfcqM
 upvSVw2s6eEEs8WwTGHlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 February 2011, Alan Cox wrote:
> This is an initial staging driver for the GMA500. It's been stripped out
> of the PVR drivers and crunched together from various bits of code and
> different kernels.
> 
> Currently it's unaccelerated but still pretty snappy even compositing with
> the frame buffer X server.
> 
> Lots of work is needed to rework the ttm and bo interfaces from being
> ripped out and then 2D acceleration wants putting back for framebuffer and
> somehow eventually via DRM.
> 
> There is no support for the parts without open source userspace (video
> accelerators, 3D) as per kernel policy.
> 
> I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
> something about DRI internals then help would be most welcome.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>

Great to see progress here!

Before I start looking at the code, one high-level question: How much of
the code in the gma500 driver would be shared with SOCs from other people
(ARM based, typically) that use the PowerVR SGX core?

IOW, is this driver only for parts that Intel (or whoever) has put around
the licensed 3D core, or is it actually the same code that the others would
use for a non-3D SGX driver?

	Arnd
