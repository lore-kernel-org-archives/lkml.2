Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1BHAyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 19:54:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50239 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1BHAyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 19:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y9tLpd5rLddxUsM0EmjD42hbQvfnSwzHLErbY4KDi48Y7fLOUJS1J8uinRxvAaq/Ko
         mBvDWTcKi3qOWqghlxBVAv+on3WJM+jIAfIbKuH96PjdDnp83ulz2oSYgMmSRmTuYkTB
         BwGkkkkCYAkHf31hR5vgCqGyEoYJ7OdiaPoqA=
Date: Mon, 7 Feb 2011 16:54:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: Matthew Garrett <mjg@redhat.com>, Henrik Rydberg <rydberg@euromail.se>,
        Daniel Mack <daniel@caiaq.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] eeepc-wmi: add camera keys
Message-ID: <20110208005442.GC24804@core.coreip.homeip.net>
References: <1296995448-5591-1-git-send-email-corentincj@iksaif.net>
 <1296995448-5591-2-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296995448-5591-2-git-send-email-corentincj@iksaif.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 01:30:47PM +0100, Corentin Chary wrote:
> These keys are supposed to be handled by any software
> using the camera (like webKam or cheese...). They can
> also be used to actually move the camera when possible.
> 
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Dmitry Torokhov <dtor@mail.ru>

Not sure if anyone is going to use these until X learns to handle > 255
keycodes. Oh well...

I also wonder if somethig like KEY_CAMERA_ZOOMRESET will be needed too.

Thanks.

-- 
Dmitry
