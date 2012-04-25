Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2DYR65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:58:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60016 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab2DYR6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:58:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120425104040.GB21469@moon>
References: <20120425104040.GB21469@moon>
Date: Wed, 25 Apr 2012 10:58:53 -0700
X-Google-Sender-Auth: CDD6FGvlolcaj735qjugWH-nvKA
Message-ID: <CAGXu5jLuNzOQnxD_TN1hSTBJFgPp+MNre3hhF253-ZYm+b42Hw@mail.gmail.com>
Subject: Re: [PATCH -mm] c/r: fs, proc: Move children entry back to tid_base_stuff
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 3:40 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> While merging to linux-next the "children" entry jumped from
> tid_base_stuff to tgid_base_stuff by mistake.
> Fix it, by moving it back.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
