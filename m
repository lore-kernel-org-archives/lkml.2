Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0LQTjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:39:44 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59036 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab0LQTjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AEv5gh5bxuHxUnwdxIAH1kjUR5mlCyU0m6AlfX9zAoAD0eYC+FY5QF3GkW4OLJDvTQ
         rbzkA7zm1yAEGF8DBh+dopjXgZyd5a/oR31nhSKJowDhRKuoiOBqWx9pqVUaDh1JjiWd
         0HFeo1tJ+oBKMhmQp2rOJdtQidyfD26QGF1Qo=
Date: Fri, 17 Dec 2010 11:39:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: introduce device information ioctl
Message-ID: <20101217193935.GB2576@core.coreip.homeip.net>
References: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292531413-28924-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 09:30:13PM +0100, Henrik Rydberg wrote:
> Today, userspace sets up an input device based on the data it emits.
> This is not always enough; a tablet and a touchscreen may emit exactly
> the same data, for instance, but the former should be set up with a
> pointer whereas the latter does not need to. Recently, a new type of
> touchpad has emerged where the buttons are under the pad, which
> changes handling logic without changing the emitted data. This patch
> introduces a new ioctl, EVIOCGPROP, which enables user access to a set
> of device properties useful during setup. The properties are given as
> a bitmap in the same fashion as the event types, and are also made
> available via sysfs.
> 

Looks good to me.

Could you please also wire up /proc/bus/input/devices to show new
'props' (I think we could use  "B: PROP=" tags for them) and also to the
uevent handler?

Thanks.

-- 
Dmitry
