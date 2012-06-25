Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab2FYSEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:04:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43372 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab2FYSEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:04:02 -0400
Date: Mon, 25 Jun 2012 20:05:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Rolland <rol@as2917.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: 3.5.0-rc3 - i915 gmbus dpb timed out
Message-ID: <20120625180539.GC4708@phenom.ffwll.local>
Mail-Followup-To: Paul Rolland <rol@as2917.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20120625192103.5dd1b4bb@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120625192103.5dd1b4bb@tux.DEF.witbe.net>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 07:21:03PM +0200, Paul Rolland wrote:
> Hello, 
> 
> I've booted a few seconds ago to a freshly compiled 3.5.0-rc3 kernel, and 
> short after starting X + KDE, I've got :
> 
> Jun 25 19:16:58 tux kernel: [drm] GMBUS [i915 gmbus dpb] timed out, falling
> back to bit banging on pin 5
> 
> in my messages.
> Nothing like that before (3.4.0-vanilla), and 3.5.0-rc4 not yet compiled.
> 
> Anything I should check and/or report to help ?

Nope, everything works as expected. This is purely an informational
message (and we might need to create a patch to make it go away on
non-debug settings).
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
