Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2EVMaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:30:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60933 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2EVMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:30:04 -0400
Date: Tue, 22 May 2012 14:30:58 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org, daniel@ffwll.ch
Subject: Re: Regression on GMA965 - display seems to have slow jump changes
 in brightness
Message-ID: <20120522123058.GB4629@phenom.ffwll.local>
Mail-Followup-To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org
References: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJJYPd=JQdzepw818ZP6OmKK4v38--T+ruKBOG_wn2pUmnVaSw@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 02:08:46PM +0200, Zdenek Kabelac wrote:
> Hi
> 
> I've updated to 3.4 kernel, and now I'm noticing slight changes in
> brightness on colorful images.
> It seems the change is mostly visibly on  'darker' images i.e. it's
> not really visible on white background.
> 
> When I reboot back to 3.3  kernel - brightness changes are gone - so I
> do not suspect hw fault of my T61 display.
> I guess once in past there has been already such bug, so this problem
> seems to me like reintroducing the same
> problem again.
> 
> xorg-x11-server-Xorg-1.12.1-1.fc18.x86_64
> with SNA intel driver build from git repo.
> T61, 965GM
> 
> Is this a know issue ?
> Is bisect needed ?

You're the first one to report things, so a bisect would be highly
appreciated. Also I'm a bit confused about what you mean by 'changing
brightness'. Can you please try to explain this a bit more?

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
