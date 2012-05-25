Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2EYHrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:47:55 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:37817 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2EYHrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:47:53 -0400
Subject: Re: [PATCH] gpu: remove gma500 stub driver
From: joeyli <jlee@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        mjg59@srcf.ucam.org, gregkh@suse.de, trenn@suse.de,
        Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de, airlied@redhat.com,
        eric@anholt.net, alexdeucher@gmail.com, bskeggs@redhat.com,
        chris@chris-wilson.co.uk
In-Reply-To: <20120525070717.GB16955@kroah.com>
References: <1337910644-21694-1-git-send-email-jlee@suse.com>
	 <20120525070717.GB16955@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 15:43:51 +0800
Message-ID: <1337931831.9751.561.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2012-05-25 於 16:07 +0900，Greg KH 提到：
> On Fri, May 25, 2012 at 09:50:44AM +0800, Lee, Chun-Yi wrote:
> > In v3.3, the gma500 drm driver moved from staging to drm group by
> > Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> > brightness well and don't need gma500 stub driver anymore.
> > 
> > Cc: randy.dunlap@oracle.com
> > Cc: mjg59@srcf.ucam.org
> > Cc: gregkh@suse.de
> 
> Note, my email address has changed :)
> 

Sorry~~~!
I will keep in mind! :-)

> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 

Thanks a lot!
Joey Lee

