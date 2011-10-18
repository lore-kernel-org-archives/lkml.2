Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab1JRA1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:27:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:50371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab1JRA1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:27:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=N7quYhr8OfscGwdH2v3uuP86HVIh/KG3RlQYX8g1D/8/zZeoe95B4wFeBk0+xnV3P
	ewqOKQsMrwwLRND/EKQug==
Date: Mon, 17 Oct 2011 17:27:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>
cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: avoid switching to text console if there is no
 panic timeout
In-Reply-To: <1318896400-32498-1-git-send-email-msb@chromium.org>
Message-ID: <alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Mandeep Singh Baines wrote:

> From: Hugh Dickins <hughd@chromium.org>
> 
> Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
> we're going to reboot immediately, the user will not be able to see the
> messages anyway, and messing with the video mode may display artifacts,
> and certainly get into several layers of complexity (including mutexes and
> memory allocations) which we shall be much safer to avoid.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> [ Edited commit message and modified to short-circuit panic_timeout < 0
>   instead of testing panic_timeout >= 0.  -Mandeep ]
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: dri-devel@lists.freedesktop.org

Acked-by: David Rientjes <rientjes@google.com>
