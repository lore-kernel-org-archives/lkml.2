Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1J1Sdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 14:33:36 -0400
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:35913
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab1J1Sdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 14:33:35 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Oct 2011 14:33:35 EDT
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Fri, 28 Oct 2011 11:24:19 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] agp: iommu_gfx_mapped only available if
 CONFIG_INTEL_IOMMU is set
Message-ID: <20111028112419.14dffa48@bwidawsk.net>
In-Reply-To: <1319824589-18082-1-git-send-email-keithp@keithp.com>
References: <1319824589-18082-1-git-send-email-keithp@keithp.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Oct 2011 10:56:29 -0700
Keith Packard <keithp@keithp.com> wrote:

> Kernels with no iommu support cannot ever need the Ironlake
> work-around, so never enable it in that case.
> 
> Might be better to completely remove the work-around from the kernel
> in this case?
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
> Cc: Ben Widawsky <ben@bwidawsk.net>
> ---
wfm Reviewed-by: Ben Widawsky <ben@bwidawsk.net>
