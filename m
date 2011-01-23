Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309Ab1AWMzc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 07:55:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51629 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1AWMzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 07:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Y0QOj5mQ7YB9ewHAWgpGRqi8My7FZugYhT0WJYUVMvW1FdgAymDxLnDuZqtHV0zU3O
         7W/1RHORwVjRzx7SpNVv+GuZp9OrSfv8fah9Fyc44T0cgP0d7j6hFTcANvN7mgne9Zu+
         zcTbmMtxuS4WB3qaxERq2GfimZKj4MBOglM2g=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915: Disable high-precision vblank timestamping for UMS
Date: Sun, 23 Jan 2011 12:55:13 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101230932.49998.chris2553@googlemail.com> <201101231128.22951.chris2553@googlemail.com> <b7da2f$q7be7q@fmsmga001.fm.intel.com>
In-Reply-To: <b7da2f$q7be7q@fmsmga001.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101231255.13967.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 January 2011, Chris Wilson wrote:
> On Sun, 23 Jan 2011 11:28:22 +0000, Chris Clayton <chris2553@googlemail.com> 
wrote:
> > Hi Chris,
> >
> > On Sunday 23 January 2011, Chris Wilson wrote:
> > > We only have sufficient information for accurate (sub-frame)
> > > timestamping when the modesetting is under our control.
> >
> > With this patch (and the earlier one) applied, X still doesn't start. At
> > the end of xorg's log file I see:
> >
> > Fatal server error:
> > Failure to wait for IRQ: No such device
>
> Now we are getting closer! The X server has been caught red-handed trying
> to use an interrupt when the driver never enabled them. Ho hum.
>
> The interrupts for UMS are only enabled between EnterVT/LeaveVT, but that
> code looks defunct. What version of xf86-video-intel are you using?

It's 2.7.1, which, IIRC, is the latest version that will build against all the 
other xorg libraries that are on my system. I'll do a quick check after lunch 
to see if any later versions will build without me going through dependency 
hell.

Thanks for your help so far,

Chris

> -Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
