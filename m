Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2BVEku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 23:40:50 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56025 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2BVEkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 23:40:49 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vapier@google.com designates 10.68.233.196 as permitted sender) smtp.mail=vapier@google.com; dkim=pass header.i=vapier@google.com
MIME-Version: 1.0
In-Reply-To: <1329883431-21652-1-git-send-email-bleung@chromium.org>
References: <1329880521-20868-1-git-send-email-bleung@chromium.org> <1329883431-21652-1-git-send-email-bleung@chromium.org>
From: Mike Frysinger <vapier@chromium.org>
Date: Tue, 21 Feb 2012 23:40:29 -0500
X-Google-Sender-Auth: JWqXC0nZl-vdIobCs3nz6R74WAk
Message-ID: <CAAbOScmLMA88Dn-BPfFLs0YHqpkQypzKjyxKFSBxCfXtXVBNdg@mail.gmail.com>
Subject: Re: [PATCH v2] tools/power x86_energy_perf_policy: fix cpuid for i686
To: Benson Leung <bleung@chromium.org>
Cc: len.brown@intel.com, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 23:03, Benson Leung <bleung@chromium.org> wrote:
> x86_energy_perf_policy reads cpuid using the cpuid instruction.
> On i686, when building with PIC, this clobbers ebx, the PIC register.
>
> Fixed using the same cpuid accessor function that vapier@chromium.org
> created for i7z:
> http://code.google.com/p/i7z/issues/detail?id=31

not sure if a-b or s-o-b ... i'll post both and you can pick most appropriate ;)

Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
