Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0EKQLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:11:00 -0400
Received: from mga10.intel.com ([192.55.52.92]:15811 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751963Ab0EKQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:10:59 -0400
Message-Id: <89kc63$grtht6@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,208,1272870000"; 
   d="scan'208";a="566151078"
Date: Tue, 11 May 2010 17:10:53 +0100
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: DRM Error on Acer Aspire One
References: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTilSNZ11CaRUH5s3w6NoAnDQ5t7U9Y0Ce-iHpq3O@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 20:30:07 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> Hello,
> 
> With latest git kernel, I am getting following DRM error and not
> getting XWindows :

[snip]

Hmm, there are still patches for capturing error state that haven't gone
upstream, shame on me.

That error is a secondary issue to the GPU hang that is being reported. If
it is a regression caused by a kernel update it would be very useful if
you could bisect to the erroneous commit.

-- 
Chris Wilson, Intel Open Source Technology Centre
