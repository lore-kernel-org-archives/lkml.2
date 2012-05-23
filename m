Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab2EWHn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:43:28 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54571 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2EWHnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:43:25 -0400
Date: Wed, 23 May 2012 09:44:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Airlie <airlied@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 03/11] intel-gtt: Read 64bit for gmar_bus_addr
Message-ID: <20120523074444.GE5062@phenom.ffwll.local>
Mail-Followup-To: Dave Airlie <airlied@gmail.com>,
	Yinghai Lu <yinghai@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	David Airlie <airlied@linux.ie>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
 <1337754877-19759-4-git-send-email-yinghai@kernel.org>
 <CAPM=9tyZLm+F1Sq3-ycOS7GmedjiU7DR-GQ=4Hj0BzaAxHHYxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tyZLm+F1Sq3-ycOS7GmedjiU7DR-GQ=4Hj0BzaAxHHYxQ@mail.gmail.com>
X-Operating-System: Linux phenom 3.4.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 08:21:51AM +0100, Dave Airlie wrote:
> On Wed, May 23, 2012 at 7:34 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > That bar could be 64bit pref mem.
> >
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> 
> Adding Daniel Vetter.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
