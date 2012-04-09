Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab2DIRwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:52:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54693 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2DIRwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:52:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120409101210.6837aee5@jbarnes-desktop>
References: <4F717CE3.4040206@suse.cz>
	<4F717D80.9040207@suse.cz>
	<4F758400.3080907@suse.cz>
	<1333104359_155028@CP5-2952>
	<4F75A303.3030409@suse.cz>
	<1333110296_156038@CP5-2952>
	<4F7F60BF.9070500@suse.cz>
	<alpine.LFD.2.02.1204062343050.2542@ionos>
	<20120409101210.6837aee5@jbarnes-desktop>
Date: Mon, 9 Apr 2012 18:52:03 +0100
Message-ID: <CAPM=9twii0kjH7494mjyqg1di2_WttucEfSUkzmtGz3XMCXjsQ@mail.gmail.com>
Subject: Re: i915_driver_irq_handler: irq 42: nobody cared [generic IRQ
 handling broken?]
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Slaby <jirislaby@gmail.com>, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> You know what? suspend calls free_irq() via i915_drm_freeze() ->
>> drm_irq_uninstall() and the resume code calls request_irq() again.
>> free_irq() removes the action and request_irq installs it fresh.
>
> Yeah this is a known issue with the DRM code, I thought Dave had a
> fix queued a long time ago though...  Dave?

/me doesn't remember seeing one but maybe this one?

http://lists.freedesktop.org/archives/dri-devel/2011-August/013407.html

probably fell down a hole.

Dave.
