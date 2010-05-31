Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0EaRFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 13:05:48 -0400
Received: from kroah.org ([198.145.64.141]:54944 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755401Ab0EaRFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 13:05:47 -0400
Date: Mon, 31 May 2010 10:02:34 -0700
From: Greg KH <greg@kroah.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: stable@kernel.org, Alex Deucher <alexdeucher@gmail.com>,
       =?iso-8859-1?B?Suly9G1l?= Glisse <glisse@freedesktop.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [stable]  please consider drm radeon kms agp release
Message-ID: <20100531170234.GA14235@kroah.com>
References: <201005311642.49843.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201005311642.49843.Martin@lichtvoll.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 04:42:41PM +0200, Martin Steigerwald wrote:
> 
> Hi Greg, hi stable kernel team,
> 
> Please consider the attached patch from Jérôme Glisse. It fixes drm radeon 
> KMS after coming out from a snapshot cycle [1] - no matter whether I use 
> userspace software suspend or TuxOnIce.
> 
> Verified on my notebook ThinkPad T42 and by cedric, the reporter of above 
> bug.

Which stable kernel release do you want to see this patch in?  .27, .32,
.33, or .34?  Yeah, there's a lot active at the moment :(

thanks,

greg k-h
