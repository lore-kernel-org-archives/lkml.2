Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab2KWIqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 03:46:17 -0500
Received: from mailout09.t-online.de ([194.25.134.84]:42003 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2KWIqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 03:46:17 -0500
Message-ID: <50AF37CC.8080400@t-online.de>
Date: Fri, 23 Nov 2012 09:46:04 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: "xorg-devel@lists.x.org Development" <xorg-devel@lists.x.org>,
        linux-kernel@vger.kernel.org
Subject: Re: drm_gem_create_mmap_offset / intel_uxa_prepare_access bo problems
References: <50AE44C4.1060606@t-online.de> <84c8a8$6kot4e@orsmga001.jf.intel.com>
In-Reply-To: <84c8a8$6kot4e@orsmga001.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: XNnKkgZaoh5klxZFRUSWZvOobo0AJ+dgs07X6+ZB0AvRIFPDtCpaSqLcJCiUF0Qwdz
X-TOI-MSGID: a5b41f34-9a55-4365-b72d-6934d12d346d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.11.2012 16:37, Chris Wilson wrote:

> Well you kernel and drm has all the latest protections, which is good because it's usually a bo leak of some sort. First stop is to check xrestop, /sys/kernel/debug/dri/0/i915_gem_objects and intel-gpu-tools/scripts/who.sh That will undoubtably reveal a large number of objects being held by the X 
> server... -Chris 

As the server had to be rebooted it will probably take some days to gather more information.

cu,
  Knut
