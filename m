Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2GDG4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:56:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46868 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2GDG4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:56:10 -0400
Date: Wed, 4 Jul 2012 10:56:06 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch] kernel/sys.c: fix an incorrect error branch in
 orderly_poweroff()
Message-ID: <20120704065606.GA1999@moon>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org>
 <1341372710-14648-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341372710-14648-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 11:31:47AM +0800, Cong Wang wrote:
> From: WANG Cong <xiyou.wangcong@gmail.com>
> 
> When argv_split() fails, argv is NULL, thus we should avoid calling
> agrv_free(argv), and should jump after it.
> 
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> ---
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Thanks!
