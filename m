Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab2D3FHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 01:07:09 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54378 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab2D3FHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 01:07:05 -0400
Date: Sun, 29 Apr 2012 21:33:13 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: "Javier M. Mellid" <jmunhoz@igalia.com>
Cc: gewang@siliconmotion.com, boyod.yang@siliconmotion.com.cn,
        wuzhangjin@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/7] staging: sm7xx: code improvements and cleanup
Message-ID: <20120430013313.GA14456@kroah.com>
References: <20120425205532.GA9642@kroah.com>
 <1335465955-32057-1-git-send-email-jmunhoz@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335465955-32057-1-git-send-email-jmunhoz@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 08:45:48PM +0200, Javier M. Mellid wrote:
> This set of patches implement some code improvements, dead code removal
> and cleanup. New code uses dynamic debug support.
> 
> The patches address new checkpatch warnings.
> 
> Patches tested with SM712.

Very nice, thanks for breaking this up, all now applied.

greg k-h
