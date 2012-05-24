Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2EXXXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:23:55 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:12343 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2EXXXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:23:54 -0400
Subject: Re: [PATCH] gpu: schedule gma500 stub driver for feature removal
From: joeyli <jlee@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de,
        airlied@redhat.com, eric@anholt.net, alexdeucher@gmail.com,
        bskeggs@redhat.com, chris@chris-wilson.co.uk
In-Reply-To: <20120524195350.GA11545@kroah.com>
References: <1337613816-12953-1-git-send-email-jlee@suse.com>
	 <20120524195350.GA11545@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 07:19:20 +0800
Message-ID: <1337901560.9751.558.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2012-05-25 於 04:53 +0900，Greg KH 提到：
> On Mon, May 21, 2012 at 11:23:36PM +0800, Lee, Chun-Yi wrote:
> > In v3.3, the gma500 drm driver moved from staging to drm group by
> > Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> > brightness well and don't need gma500 stub driver anymore.
> > 
> > So, my plan is remove gma500 stub driver at Dec. 2012.
> 
> Why not just remove it right now as it's not needed at all anymore?
> 
> thanks,
> 
> greg k-h
> 
> .

Just I thought remove anything from kernel need add to schedule file
first.

OK, I will send another patch to direct remove it.


Thanks
Joey Lee

