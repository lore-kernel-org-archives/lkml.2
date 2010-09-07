Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab0IGFGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:06:46 -0400
Received: from eazy.amigager.de ([213.239.192.238]:34912 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab0IGFGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:06:42 -0400
Date: Tue, 7 Sep 2010 07:07:15 +0200
From: Tino Keitel <tino.keitel+xorg@tikei.de>
To: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [git pull] i915
Message-ID: <20100907050715.GA5863@mac.home>
Mail-Followup-To: intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <89kc63$i063ms@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89kc63$i063ms@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 09:30:23 +0100, Chris Wilson wrote:

[...]

> This batch of fixes include the timing fixes for the fallout from the
> conversion of intel_wait_for_vblank() and the error checking for SDVO
> modesetting. It also includes a [double dose] of module unload oopsen

Thanks, this branch fixes all my problems I reported in the thread
http://lkml.org/lkml/2010/8/26/56 (wrong screen resolution due to buggy
TV out detection, no signal on monitor after resume from suspend to
RAM).

Regards,
Tino
