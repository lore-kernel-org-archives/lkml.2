Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0H3JgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:36:22 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:55280 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751747Ab0H3JgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:36:21 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/Ze89uznrZP9ia6RPBJdEy7YKyczYDb4dAPv+iWF
	NPsc9430gkpzbS
From: Sven Joachim <svenjoac@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: i915: wrong framebuffer size in 2.6.36-rc3
Date: Mon, 30 Aug 2010 11:36:16 +0200
Message-ID: <87wrr8cui7.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my laptop which has a 1280x800 display, only the upper left 848x480
pixels are used on the console in 2.6.36-rc3.  The resolution is
correct, but /sys/class/graphics/fb0/modes looks like this:

U:848x480p-0

This is a regression from 2.6.35.  The graphics card according to lspci:

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
943/940GML Express Integrated Graphics Controller (rev 03)

Sven
