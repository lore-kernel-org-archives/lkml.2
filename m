Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab0GYQLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 12:11:22 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50028 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab0GYQLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:11:18 -0400
Date: Sun, 25 Jul 2010 17:58:34 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linux-kernel@vger.kernel.org
Subject: [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
Message-ID: <20100725155834.GJ31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

I tried to run Xorg w/o dri on my notebook. Some time afterwards, a couple of
suspend/resume cycles later, X crashed, showing ugly screens of horizontal and
vertical stripes all over.

Is this solely due to a X/dri bug? Shouldn't it be possible to run X w/o dri?
Or might this indicate failing hardware, maybe graphics card or memory corrupt?

Apr 10 15:55:28 localhost kernel: [   85.938067] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed...
+GPU hung
Apr 10 15:55:28 localhost kernel: [   85.938085] render error detected, EIR: 0x00000000
Apr 10 15:55:28 localhost kernel: [   85.938122] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns
+-5 (awaiting 2 at 1)

  Thanks,

    Nils

