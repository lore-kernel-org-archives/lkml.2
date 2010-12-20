Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab0LTQBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:01:33 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57747 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab0LTQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:01:32 -0500
Date: Tue, 21 Dec 2010 01:00:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: "Janorkar, Mayuresh" <mayur@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: Re: [PATCH 1/2] fbdev: Minor cleanup in WM8505-related code
Message-ID: <20101220160001.GD26766@linux-sh.org>
References: <20101219181300.GA32645@alchark-u3s> <EAF47CD23C76F840A9E7FCE10091EFAB0322F86AE6@dbde02.ent.ti.com> <20101220130314.GA3627@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220130314.GA3627@alchark-u3s>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:03:14PM +0300, Alexey Charkov wrote:
> This replaces the last remaining driver name reference with the
> macro for uniformity in wm8505fb.
> 
> In addition, the error return path in wmt_ge_rops.c is made more
> uniform by getting rid of goto's in remaining places.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>

I'll hold on to this for .38, as there's nothing really pressing here.
