Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306Ab1AHMqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 07:46:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:50628 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1AHMqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 07:46:52 -0500
Message-Id: <b9dded$hjmdu0@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,293,1291622400"; 
   d="scan'208";a="591083456"
Date: Sat, 08 Jan 2011 12:46:48 +0000
To: Pavel Machek <pavel@ucw.cz>, Dave Airlie <airlied@gmail.com>
Subject: Re: Linux 2.6.37-rc8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20000101001300.GA1627@ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com> <20110104142604.GA6591@ucw.cz> <849307$b0n4jp@azsmga001.ch.intel.com> <20110104210408.GA2008@elf.ucw.cz> <AANLkTim2PC5tgLfuz4+jO4L_xSX9bPuLhy+gtE2mgcJH@mail.gmail.com> <20110105220533.GA2700@elf.ucw.cz> <AANLkTikq9QHDk2zN+b8LFjrfqmHgtHWS8nT42hfiSwrz@mail.gmail.com> <20110106202712.GA1967@elf.ucw.cz> <20000101001300.GA1627@ucw.cz>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Jan 2000 01:13:01 +0100, Pavel Machek <pavel@ucw.cz> wrote:
> One more question: what kind of 3D performance should I expect?
> glxgears get < 100 fps in 1024x768 mode, and flightgear is unusable.

glxgears should be vsync'ed, and flightgear would be expecting a little
too much from the 945. World of Padman is about the limit of the
complexity that 945 can handle and remain playable. On the other hand, it
is a very able performer for "2D" compositing.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
