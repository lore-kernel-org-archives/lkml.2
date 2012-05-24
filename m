Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965674Ab2EXVf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:35:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965637Ab2EXVf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:35:57 -0400
Date: Fri, 25 May 2012 04:53:50 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>, randy.dunlap@oracle.com,
        mjg59@srcf.ucam.org, gregkh@suse.de, trenn@suse.de,
        Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk
Subject: Re: [PATCH] gpu: schedule gma500 stub driver for feature removal
Message-ID: <20120524195350.GA11545@kroah.com>
References: <1337613816-12953-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337613816-12953-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 11:23:36PM +0800, Lee, Chun-Yi wrote:
> In v3.3, the gma500 drm driver moved from staging to drm group by
> Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> brightness well and don't need gma500 stub driver anymore.
> 
> So, my plan is remove gma500 stub driver at Dec. 2012.

Why not just remove it right now as it's not needed at all anymore?

thanks,

greg k-h
