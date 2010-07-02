Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0GBCqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 22:46:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0GBCqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 22:46:42 -0400
Subject: Re: Closed source userspace graphics drivers with an open source 
 kernel component
From: Dave Airlie <airlied@redhat.com>
To: Timothy Meade <zt.tmzt@gmail.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, linux-arm-msm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	 <AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	 <1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
	 <1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
	 <1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
	 <AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
	 <4C2D3066.9040104@codeaurora.org>
	 <AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com>
	 <AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
	 <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Jul 2010 12:46:36 +1000
Message-ID: <1278038796.19705.21.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 20:42 -0400, Timothy Meade wrote:
> ---------- Forwarded message ----------

> Hello.  I've been working with the developers on the htc-linux project
> and following the progress of Android on MSM devices closely for a few
> years.  I've been excitied to see DRM/DRI replace PMEM and the Android
> specific interfaces be replaced with more Linux-like ones.  The Xorg
> driver from Qualcomm uses this same interface for 2D and it's possible
> that Android will take the same approach, though it uses 3D and GLES
> as a type of abstraction layer for surfaceflinger.  This allows for a
> closed 3D driver with an open command submission layer that is in
> itself not that different from the split for ATI devices using
> radeonhd.  I say this because the alternative for these devices is a
> fully closed binary and secrecy surrounding the graphics layers that
> ensures that only the OS that ships with the device can ever really be
> used and preventing those non-coorporate developers as myself from
> utilising GPL code the way we want or even usuing are own cell phones
> (in this case).  I would choose a fully open, X based OS even if that
> meant only having 2D drivers, but I know that Quic and others aren't
> going to develop just a (accelerated) 2D driver, not the kernel
> components or userspace but instead rely on the same GLES layer that
> Android uses, essentially making X and open environments a second
> class citizen on modern mobile hardware.

The thing is you are prevented from using the GPU the way you want,
telling you how to send commands and get irqs from a device but not
telling you what those commands means is limiting you. So you can use it
a framebuffer device, you can do that with a 500 line fbdev driver most
likely, we don't need the maintainer burden of the other 5000 lines of
code that are only in the driver to service some 3D userspace binary
blob.

The radeon example is pointless since all pieces in that system are open
even if AMD can't/won't disclose how certain parts of the GPU work, we
have access to nearly all the functionality, we control all the open
pieces and if someone reverse engineers it, AMD have to accept it.

There is no point supporting companies that give you a little bit of
information in exchange they want the support that being in a mainline
kernel gives. Its an unfair exchange of knowledge and time, and if they
claim they have to make a profit then its even more unfair.

Dave.


