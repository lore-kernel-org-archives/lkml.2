Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2A0S37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:29:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64154 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab2A0S35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:29:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120127175939.862102158@openvz.org>
References: <20120127175342.273260614@openvz.org>
	<20120127175939.862102158@openvz.org>
Date: Fri, 27 Jan 2012 10:29:57 -0800
X-Google-Sender-Auth: vEZ2mt1Rw7t4iL9NlAK1u6lt_vo
Message-ID: <CAGXu5jJBjJstRL5YbJsTLL4t66u7TR_oXowzDevMrQSmC0O3ug@mail.gmail.com>
Subject: Re: [RFC c/r 3/4] c/r: procfs: add arg_start/end, env_start/end and
 exit_code members to /proc/$pid/stat
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 9:53 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> We would like to have an ability to restore command line
> arguments and envirion pointers so the task being restored
> would print appropriate values in /proc/pid/cmdline and
> /proc/pid/envirion. The exit_code is needed to restore
> zombie tasks.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

> +               if (mm && permitted) {
> +                       seq_printf(m, "%lu %lu %lu %lu %lu %lu %lu ",

I like this clean-up. :)

-Kees

-- 
Kees Cook
ChromeOS Security
