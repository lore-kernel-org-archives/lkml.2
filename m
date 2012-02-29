Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab2B2MeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:34:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55430 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab2B2MeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:34:12 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.10.91 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Wed, 29 Feb 2012 16:34:08 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-man@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] Add kcmp.2 manpage
Message-ID: <20120229123408.GC11326@moon>
References: <1330518197-12825-1-git-send-email-gorcunov@openvz.org>
 <1330518197-12825-3-git-send-email-gorcunov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330518197-12825-3-git-send-email-gorcunov@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 04:23:17PM +0400, Cyrill Gorcunov wrote:
> 
>        The  easiest way to explain is to consider an example.  Lets say v1 and v2
>        are the addresses of appropriate resources, then the return value is one
>        of the following
> 
>        0 - v1 is equal to v2 , in other words we have a shared resource here
> 
>        1 - v1 is greater than v2
> 
>        2 - v1 is less than v2

1 and 2 should be swapped here, I'll update (this nit grow from text tossing,
so don't pay attention on it).

	Cyrill
