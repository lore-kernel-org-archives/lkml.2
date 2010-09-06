Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0IFSd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:33:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54691 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab0IFSdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:33:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [git pull] i915
Date: Mon, 6 Sep 2010 20:32:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Sven Joachim <svenjoac@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <89kc63$i063ms@fmsmga002.fm.intel.com> <8739tnw7ax.fsf@turtle.gmx.de> <89k83a$9icvuq@azsmga001.ch.intel.com>
In-Reply-To: <89k83a$9icvuq@azsmga001.ch.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009062032.59486.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 06, 2010, Chris Wilson wrote:
> On Mon, 06 Sep 2010 11:27:34 +0200, Sven Joachim <svenjoac@gmx.de> wrote:
> > Sadly, these still do not include a fix for the build failure¹ that
> > occurs if CONFIG_DEBUG_FS is not set:
> > 
> > ,----
> > |   CC [M]  drivers/gpu/drm/i915/intel_overlay.o
> > | drivers/gpu/drm/i915/intel_overlay.c: In function 'intel_overlay_print_error_state':
> > | drivers/gpu/drm/i915/intel_overlay.c:1467: error: implicit declaration of function 'seq_printf'
> > | make[4]: *** [drivers/gpu/drm/i915/intel_overlay.o] Error 1
> 
> Andrew Morton picked up a patch to fix that, hence why I left it out.

You shouldn't.  Andrew automatically drops patches that have been taken by
maintainers and it's better if fixed are merged through the right tree.

Thanks,
Rafael
