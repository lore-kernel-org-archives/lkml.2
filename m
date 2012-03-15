Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2COCmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:42:22 -0400
Received: from home.keithp.com ([63.227.221.253]:34790 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745Ab2COCmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:42:21 -0400
From: Keith Packard <keithp@keithp.com>
To: Carsten Emde <C.Emde@osadl.org>, David Airlie <airlied@linux.ie>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [V2 PATCH 2/2] drivers-gpu-drm-i915-invert-backlight-brightness
In-Reply-To: <20120314234830.227490545@osadl.org>
References: <20120314233544.629616190@osadl.org> <20120314234830.227490545@osadl.org>
User-Agent: Notmuch/0.11.1 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Wed, 14 Mar 2012 19:42:16 -0700
Message-ID: <8662e6inzr.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<#part sign=pgpmime>
On Thu, 15 Mar 2012 00:35:46 +0100, Carsten Emde <C.Emde@osadl.org> wrote:

> This patch adds a module parameter to invert the backlight brightness
> value before writing and after reading which makes the affected notebook
> usable again.

You should add a quirk for this and set things up so that your machine
automatically gets the right value; when we find more machines that do
this, we can add them so that more people will get a system that 'just
works'.

-- 
keith.packard@intel.com
