Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1J1PsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 11:48:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44449 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab1J1PsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 11:48:21 -0400
Date: Fri, 28 Oct 2011 08:48:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC/PATCH 7/7] x86, mm: Unify zone_sizes_init()
Message-ID: <20111028154815.GA29806@google.com>
References: <1319811801-1725-1-git-send-email-penberg@kernel.org>
 <1319811801-1725-7-git-send-email-penberg@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319811801-1725-7-git-send-email-penberg@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 05:23:21PM +0300, Pekka Enberg wrote:
> Now that zone_sizes_init() is identical on 32-bit and 64-bit, move the code to
> arch/x86/mm/init.c and use it for both architectures.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

For all seven patches in this series.

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
