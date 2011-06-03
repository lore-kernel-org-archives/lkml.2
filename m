Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab1FCUVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:21:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48709 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab1FCUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:21:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=EKO6CYU4xfwt2aglLYS7hXCDpGruc69EVevlZUxP11mdAREiC+6HlH+8maY8p9Ilom
         ShlNWTXToWb8qu32+Z4hn753aXGC0UVaYxfoz1jnUNN1Grw/zK5cUvFfe35O25Scriu6
         oy3IGIw0Pcx9loaYscFW7kUCIpbk+0bAN913c=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Subject: Re: [PATCH 2/3] ideapad: Add nodes in sysfs
Date: Fri, 3 Jun 2011 13:21:41 -0700
User-Agent: KMail/1.13.7 (Linux/2.6.39-rc7+; KDE/4.6.3; x86_64; ; )
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <1307006553-12667-1-git-send-email-ike.pan@canonical.com> <1307006645-12702-1-git-send-email-ike.pan@canonical.com>
In-Reply-To: <1307006645-12702-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106031321.42168.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 02, 2011 02:24:05 AM Ike Panhc wrote:
> +What:          /sys/devices/platform/ideapad/touchpad
> +Date:          Jun 2011
> +KernelVersion: 3.0.1
> +Contact:       "Ike Panhc <ike.pan@canonical.com>"
> +Description:
> +               Control the power of touchpad. 1 means on, 0 means off.

I do not think that we should be adding attributes like this one.
Is there any way to pug it into device core/PM infrastructure?

Also, what is the driver for having this attribute? Is it power savings
or is it because some people prefer to turn off the touchpad because
it interferes with typing?

Thanks.

-- 
Dmitry
