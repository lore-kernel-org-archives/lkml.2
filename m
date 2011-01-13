Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab1AMEMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:12:06 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38935 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab1AMEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:12:05 -0500
Date: Thu, 13 Jan 2011 13:09:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH] fbdev: Implement simple blanking in pseudocolor modes for vt8500lcdfb
Message-ID: <20110113040953.GB12013@linux-sh.org>
References: <20110112221443.GA574@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110112221443.GA574@alchark-u3s>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 01:14:44AM +0300, Alexey Charkov wrote:
> Implement simple blanking in pseudocolor modes for vt8500lcdfb
> 
> This follows the style of some other in-tree drivers by just setting
> the hardware palette colors to all black. True Color modes are not
> affected, but this at least allows to run xf86-video-fbdev without
> errors due to blanking being unimplemented.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> 
Applied, thanks.
