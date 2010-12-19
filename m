Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0LSIHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 03:07:31 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55137 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0LSIHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 03:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mxhjlOPlfk1EjboGkIQBi3Ze1EkRrCTByZszGK7291+ntkwxw412++qM9D8fFo7lrp
         TPCcd6q9i07ZEhdoRlKrVbvcT1tRprkHU/RRvk0px79CsWOnIFWdHh3RABHrNeUY6+e0
         Yo2e440KCH86b3Xznls7Uzz2Ps9nyjZsCvf70=
Date: Sun, 19 Dec 2010 00:07:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: introduce device properties
Message-ID: <20101219080723.GB10074@core.coreip.homeip.net>
References: <1292702719-1552-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292702719-1552-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 09:05:19PM +0100, Henrik Rydberg wrote:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which
> changes logic without changing the emitted data. This patch introduces
> a new ioctl, EVIOCGPROP, which enables user access to a set of device
> properties useful during setup. The properties are given as a bitmap
> in the same fashion as the event types, and are also made available
> via sysfs, uevent and /proc/bus/input/devices.
> 
> Acked-by: Ping Cheng <pingc@wacom.com>
> Acked-by: Chase Douglas <chase.douglas@canonical.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Looks good to me, thanks for making changes.

BTW, we need to figure out how to tell when you CC me for review/FYI but
will push the patch through your tree and when you want me to apply the
patch directly to my tree.

Thanks.

-- 
Dmitry
