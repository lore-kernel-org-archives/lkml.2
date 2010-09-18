Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab0IRVJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 17:09:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36924 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab0IRVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 17:09:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ydy2Z5PguGZCufEHLpP+ZRuBxvxaTcG9MxNGE6rW7fy67jA4h/snPjKNmZt/+hBkJ2
         RkONM0Y0GZYXVYmu5FE9uGeMu0aKlq6ZQmuKBuS/ETXfq4nov5dcOwtkI+h+vA5MKoe2
         RF6sRqUkxD6+Vj56tPEiUHSV1o0K4epK4kUlM=
Date: Sat, 18 Sep 2010 23:08:00 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [000/129] 2.6.35.5 -stable review
Message-ID: <20100918210800.GA2886@joi.lan>
References: <20100918191317.GA11386@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918191317.GA11386@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 12:13:17PM -0700, Greg KH wrote:
> [Note, I do still have patches that people have sent me for inclusion in
> the .35-stable tree in my queue, but I figured this series was already
> big enough that it should go out now.  If you notice, I _did_ apply all
> patches that went through Linus's tree with a stable@kernel.org marking
> on it, so people might consider using that method instead...]
> 
> This is the start of the stable review cycle for the 2.6.35.5 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
> 
> Responses should be made by @date (day, month date, time)@ UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.35.5-rc1.gz
> and the diffstat can be found below.

Greg,
please consider applying patch 615661f3948a066fd22a36fe8ea0c528b75ee373 
"drm/nv50: initialize ramht_refs list for faked 0 channel"
for .35-stable.

Thanks,
Marcin
