Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2DYUzh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:55:37 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:34674 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab2DYUzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:55:36 -0400
Date: Wed, 25 Apr 2012 13:55:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Javier M. Mellid" <jmunhoz@igalia.com>
Cc: gewang@siliconmotion.com, boyod.yang@siliconmotion.com.cn,
        wuzhangjin@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: sm7xx: code improvements and cleanup
Message-ID: <20120425205532.GA9642@kroah.com>
References: <1335387028-29652-1-git-send-email-jmunhoz@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335387028-29652-1-git-send-email-jmunhoz@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 10:50:28PM +0200, Javier M. Mellid wrote:
> This patch implements some code improvements and cleanup.
> 
> New code uses dynamic debug support. Old debug calls updated/tested to
> use this API.
> 
> Cleanup on obsolete references, internal versions and some
> comments. Dead code removal.
> 
> Patch tested with SM712.
> 
> Changes:
> 
> - Code improvements and cleanup
> - Use dynamic debug support
> - Remove out-of-date comments/references
> - Remove dead code

Can you please break this down into individual patches, each doing only
one thing, so that we can review it easier?  Otherwise, it's quite
difficult, which is one reason why we require patches to be created this
way.

thanks,

greg k-h
