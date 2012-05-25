Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2EYHHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:07:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49312 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2EYHH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:07:29 -0400
Date: Fri, 25 May 2012 16:07:17 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>,
        randy.dunlap@oracle.com, mjg59@srcf.ucam.org, gregkh@suse.de,
        trenn@suse.de, Valdis.Kletnieks@vt.edu, Dennis.Jansen@web.de,
        airlied@redhat.com, eric@anholt.net, alexdeucher@gmail.com,
        bskeggs@redhat.com, chris@chris-wilson.co.uk
Subject: Re: [PATCH] gpu: remove gma500 stub driver
Message-ID: <20120525070717.GB16955@kroah.com>
References: <1337910644-21694-1-git-send-email-jlee@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337910644-21694-1-git-send-email-jlee@suse.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 09:50:44AM +0800, Lee, Chun-Yi wrote:
> In v3.3, the gma500 drm driver moved from staging to drm group by
> Alan Cox's 3abcf41fb patch. the gma500 drm driver should control
> brightness well and don't need gma500 stub driver anymore.
> 
> Cc: randy.dunlap@oracle.com
> Cc: mjg59@srcf.ucam.org
> Cc: gregkh@suse.de

Note, my email address has changed :)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

