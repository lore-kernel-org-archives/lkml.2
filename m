Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0DLVmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:42:40 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:51470 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab0DLVmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:42:39 -0400
Message-ID: <4BC393C0.2000407@epsm.fr>
Date: Mon, 12 Apr 2010 23:42:24 +0200
From: Didier Spaier <didier.spaier@epsm.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100404)
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net, Dave Airlie <airlied@linux.ie>,
       Ben Kseggs <bskeggs@redhat.com>
Subject: Re: [Nouveau] nouveau userspace bits for 2.6.34
References: <20100412212203.GA2671@hexapodia.org>
In-Reply-To: <20100412212203.GA2671@hexapodia.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Isaacson wrote:

> 
> What version of libdrm-nouveau and xserver-xorg-video-nouveau do I need
> in order to run nouveau on 2.6.34-rc3 and later?
> 
On Slackware 64-current using unmodified 2.6.34-rc3 with libdrm-2.4.19 and xf86-video-nouveau pulled from git commit 2462b417fc550b71f021ca9736808f8f2d1cb6f0 works well.
 >
> What git branches should I be tracking?  What changesets add support for
> nouveau interface version 0.0.16?
> 
> (I'm on Debian and Ubuntu, but building my own from git is fine.)
> 
Didier
