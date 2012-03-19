Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162251Ab2CSQvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:51:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42135 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162218Ab2CSQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:51:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120316210343.993662395@openvz.org>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.993662395@openvz.org>
Date: Mon, 19 Mar 2012 09:51:36 -0700
X-Google-Sender-Auth: GNudcAVSKf5fP8zNClM29M4Nx5M
Message-ID: <CAGXu5jJq5yQDadMpRasXNOV3=auRF5WbyyEf3bodf42veg9F0g@mail.gmail.com>
Subject: Re: [patch 2/2] c/r: prctl: Add ability to get clear_tid_address
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Andrew Vagin <avagin@openvz.org>,
        Pedro Alves <palves@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 1:55 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> Zero is written at clear_tid_address, when
> the process exits. This functionality is used
> by pthread_join().
>
> We already have sys_set_tid_address() to change this
> address for current task but there is no way to obtain
> it from a user space.

Is it worth introducing a syscall for this just for symmetry? I
suspect not, in which case:

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
ChromeOS Security
