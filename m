Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab2BCQhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:37:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54883 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab2BCQhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <20120203152650.827624790@openvz.org>
References: <20120203151928.474036973@openvz.org>
	<20120203152650.827624790@openvz.org>
Date: Fri, 3 Feb 2012 08:37:40 -0800
X-Google-Sender-Auth: Q0RUfakBJCI88EC76UN7nBB4X0k
Message-ID: <CAGXu5jKeF65oTHTzuWQ3m+Hne=JkMtSZMAKWPrneL0+v=Hjz7g@mail.gmail.com>
Subject: Re: [patch 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 7:19 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> We would like to have an ability to restore command line
> arguments and program environment pointers but first we
> need to obtain them somehow. Thus we put these values into
> /proc/$pid/stat. The exit_code is needed to restore zombie
> tasks.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
