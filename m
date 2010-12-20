Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab0LTQBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:01:50 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57756 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab0LTQBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:01:48 -0500
Date: Tue, 21 Dec 2010 01:00:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: "Janorkar, Mayuresh" <mayur@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: [PATCH 2/2] fbdev: Modify vsync timing calculation in wm8505fb
Message-ID: <20101220160018.GE26766@linux-sh.org>
References: <20101220130314.GA3627@alchark-u3s> <20101220130957.GB3627@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220130957.GB3627@alchark-u3s>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:09:57PM +0300, Alexey Charkov wrote:
> This removes the '+1' in vsync timing calculation for wm8505fb to
> directly use values provided from the board setup code.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

This is queued for .37, thanks.
