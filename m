Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab0HTHvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 03:51:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48443 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab0HTHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 03:51:33 -0400
Date: Fri, 20 Aug 2010 09:51:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: Regression in 2.6.36-rc1 bisected to commit 9d8888c
Message-ID: <20100820075125.GA23650@aftab>
References: <4C6DE7E3.4030702@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6DE7E3.4030702@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Thu, Aug 19, 2010 at 09:26:43PM -0500

> With 2.6.36-rc1 from the mainline git tree, my x86_64 system running on an AMD
> Turion 64 x2 TL-60 has required pressing keys to get booting to advance. This
> behavior begins as soon as the kernel is loaded. I bisected the problem to:
> 
> commit 9d8888c2a214aece2494a49e699a097c2ba9498b
> Author: Hans Rosenfeld <hans.rosenfeld@amd.com>
> Date:   Wed Jul 28 19:09:31 2010 +0200
> 
>     x86, cpu: Clean up AMD erratum 400 workaround
> 
>     Remove check_c1e_idle() and use the new AMD errata checking framework
>     instead.
> 
>     Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
>     LKML-Reference: <1280336972-865982-2-git-send-email-hans.rosenfeld@amd.com>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> Reverting this patch allows the current 2.6.36-rc1+ to boot normally.
> 
> This problem is entered into the Kernel Bugzilla as Bug #16636.

Fix is already upstream: http://git.kernel.org/tip/07a7795ca2e6e66d00b184efb46bd0e23d90d3fe

Can you verify it fixes your issue too please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
