Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0C0QxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 12:53:23 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:53232 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0C0QxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 12:53:22 -0400
X-Greylist: delayed 2536 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Mar 2010 12:53:22 EDT
Date: Sun, 28 Mar 2010 01:11:05 +0900
To: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: intel graphic card hanging (Hangcheck timer elapsed... GPU hung)
Message-ID: <20100327161104.GA12043@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

(please Cc)

I am running 2.6.34-rc2 + git 01e7770 commit (yesterday) with KMS on Debian/sid:
xserver-xorg: 7.5+5
video-intel: 2.9.1-3

Running D2X-xl (self compiled) (descent2 open source code) X suddenly died,
and after that gdm could not be restarted because after a few secs
it went dead again.

In the logs I see:
kernel: [ 2486.341227] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
kernel: [ 2486.341240] render error detected, EIR: 0x00000000
kernel: [ 2486.341278] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113671 at 113604)
kernel: [ 2486.669008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
kernel: [ 2486.669012] render error detected, EIR: 0x00000000
kernel: [ 2486.669522] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113672 at 113604)
kernel: [ 2487.524230] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
kernel: [ 2487.524243] render error detected, EIR: 0x00000000
kernel: [ 2487.524284] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113673 at 113604)
kernel: [ 2487.912237] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
kernel: [ 2487.916175] render error detected, EIR: 0x00000000
kernel: [ 2487.920137] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (awaiting 113674 at 113604)

Stopping gdm and restarting didn't help to get the graphics card back to normal.

If you have any ideas how to fix/track/debug that please let me know,
same if you need more information.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
HUCKNALL (vb.)
To crouch upwards: as in the movement of a seated person's feet and
legs made in order to allow a cleaner's hoover to pass beneath them.
			--- Douglas Adams, The Meaning of Liff
