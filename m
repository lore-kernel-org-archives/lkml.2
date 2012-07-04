Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2GDGpE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:45:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65066 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2GDGpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:45:01 -0400
Date: Tue, 3 Jul 2012 23:44:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Kees Cook <keescook@chromium.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Patch] kernel/sys.c: fix an incorrect error branch in
 orderly_poweroff()
In-Reply-To: <1341372710-14648-1-git-send-email-amwang@redhat.com>
Message-ID: <alpine.DEB.2.00.1207032344470.32556@chino.kir.corp.google.com>
References: <20120703152739.ea7df9e6.akpm@linux-foundation.org> <1341372710-14648-1-git-send-email-amwang@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Cong Wang wrote:

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

Acked-by: David Rientjes <rientjes@google.com>
