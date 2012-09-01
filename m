Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2IALgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 07:36:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39087 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab2IALgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 07:36:35 -0400
Date: Sat, 1 Sep 2012 13:37:03 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Paul Rolland <rol@as2917.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: Linux 3.5.3 - i915 error
Message-ID: <20120901113703.GC7528@phenom.ffwll.local>
Mail-Followup-To: Paul Rolland <rol@as2917.net>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20120831093417.3d92b8e5@tux.DEF.witbe.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831093417.3d92b8e5@tux.DEF.witbe.net>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 09:34:17AM +0200, Paul Rolland wrote:
> Hello,
> 
> I've just found this error in my logs. It occured once so far, but I never
> got it before with 3.5.0, so I'm reporting it.
> 
> [drm] capturing error event; look for more information
> in /debug/dri/0/i915_error_state 
> i915: render error detected, EIR: 0x00000010 
> i915:   IPEIR: 0x00000000
> i915:   IPEHR: 0x01000000
> i915:   INSTDONE: 0xfffffffe
> i915:   INSTPS: 0x0001e000
> i915:   INSTDONE1: 0xffffffff
> i915:   ACTHD: 0xad01f678
> i915: page table error
> i915:   PGTBL_ER: 0x00000001
> [drm:i915_report_and_clear_eir] *ERROR* EIR stuck: 0x00000010, masking
> 
> Content of /debug/dri/0/i915_error_state attached as error.gz

On a quick look this is a hange in the gen4 mesa code, nothing gone wrong
that could be blamed on the kernel part of the driver. Please upgrade to
the latest mesa (maybe even try git). If you can still reproduce this (and
you've figured out a way to reliably reproduce this), please file a bug
on bugs.freedesktop.org agains mesa -> intel/i965.

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
