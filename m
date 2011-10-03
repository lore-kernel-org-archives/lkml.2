Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1JCUey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:34:54 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:47189 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752994Ab1JCUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:34:50 -0400
Date: Mon, 3 Oct 2011 13:34:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 01/21] drm/i915: Enable digital port hotplug
 on PCH systems
Message-ID: <20111003133438.54579f5c@jbarnes-desktop>
In-Reply-To: <20110930161732.GA2859@phenom.ffwll.local>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
	<1317344993-24945-1-git-send-email-keithp@keithp.com>
	<1317344993-24945-2-git-send-email-keithp@keithp.com>
	<20110930161732.GA2859@phenom.ffwll.local>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 18:17:32 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Thu, Sep 29, 2011 at 06:09:33PM -0700, Keith Packard wrote:
> > We were relying on the BIOS to set these bits, which doesn't always
> > happen.
> > 
> > Signed-off-by: Keith Packard <keithp@keithp.com>
> 
> Ok, I'll try to increase our review-bandwidth for modesetting stuff by
> jumping into this maze myself. For the moment I'll shortly explain what
> I've actually checked so you know how much weight/little to attach to my
> r-b's.
> 
> Checked with docs, noticed that the public one's lack register addresses
> for PCH regs ...
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Yep, I like it too:

Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
