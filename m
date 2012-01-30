Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2A3K2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:28:33 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:54754
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab2A3K2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:28:32 -0500
X-IronPort-AV: E=Sophos;i="4.71,591,1320620400"; 
   d="scan'208";a="129371170"
Date: Mon, 30 Jan 2012 11:28:31 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Dave Airlie <airlied@gmail.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: question about drivers/gpu/drm/drm_ioc32.c
In-Reply-To: <CAPM=9twMwts87HLEKCMd68etvwyrS=rDxRcytCPU+7_7MonpZQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1201301125270.1934@localhost6.localdomain6>
References: <alpine.DEB.2.02.1201282026500.1973@hadrien> <CAPM=9twMwts87HLEKCMd68etvwyrS=rDxRcytCPU+7_7MonpZQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Dave Airlie wrote:

> On Sat, Jan 28, 2012 at 7:28 PM, Julia Lawall <julia.lawall@lip6.fr> wrote:
>> In the function compat_drm_getclient, I have the impression that the
>> structure c32 is copied to user level with the field idx uninitialized?
>
> Looks like it alright,
>
> care to send a patch?

What should it be initialized to?  The idx value that was got and put 
earlier?

thanks,
julia
