Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1LLUkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:40:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40631 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1LLUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:40:35 -0500
MIME-Version: 1.0
In-Reply-To: <20111212201715.057471762@openvz.org>
References: <20111212200642.836001668@openvz.org>
	<20111212201715.057471762@openvz.org>
Date: Mon, 12 Dec 2011 12:40:35 -0800
X-Google-Sender-Auth: P9P2IudprbZcS2FxyTvdb2kY_Qc
Message-ID: <CAGXu5j+q_WJECSfnG49wtHaiF7+kNgUYFj9DQPRVhhp6gpVJdg@mail.gmail.com>
Subject: Re: [patch 1/3] Kconfig: Introduce CHECKPOINT_RESTORE symbol
From: Kees Cook <keescook@chromium.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:06 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> In a sake of checkpoint/restore we need auxilary
> features being compiled into the kernel, such as additional
> prctl codes, /proc/<pid>/map_files and etc...
> but same time these features are not mandatory for a
> regular kernel so CHECKPOINT_RESTORE config symbol should
> bring a way to disable them all at once if one wish to get
> rid of additional functionality.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
ChromeOS Security
