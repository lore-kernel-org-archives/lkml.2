Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2E3V6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:58:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731Ab2E3V6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:58:52 -0400
Date: Wed, 30 May 2012 17:58:48 -0400
From: Dave Jones <davej@redhat.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: Lots of i915/drm spew on 3.4
Message-ID: <20120530215848.GB19223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20120530213128.GA10407@redhat.com>
 <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uE7RtzFd1RR4gyOaStSEisircr7gC7sz5BwVNiy2EtV+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:51:54PM +0200, Daniel Vetter wrote:
 > On Wed, May 30, 2012 at 11:31 PM, Dave Jones <davej@redhat.com> wrote:
 > > On this hardware:
 > >
 > > 00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
 > >
 > > I get this every boot with Linus current tree (up to af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76)
 > 
 > Just a quick question, is this a regression? 

seems so, I don't see it on 3.3

 > If so, can you please
 > attach the output of xrandr --verbose from a noisy and a quite kernel
 > (otherwise just please attach it from this noisy kernel).

this machine runs headless, so has no X installed right now, I'll get it in a while.

	Dave

