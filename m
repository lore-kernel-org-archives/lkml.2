Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab2BVDli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 22:41:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62151 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab2BVDlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 22:41:37 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of vapier@google.com designates 10.68.132.134 as permitted sender) smtp.mail=vapier@google.com; dkim=pass header.i=vapier@google.com
MIME-Version: 1.0
In-Reply-To: <1329880521-20868-1-git-send-email-bleung@chromium.org>
References: <1329880521-20868-1-git-send-email-bleung@chromium.org>
From: Mike Frysinger <vapier@chromium.org>
Date: Tue, 21 Feb 2012 22:41:17 -0500
X-Google-Sender-Auth: H2p2SRl4LfxYoaw8Zc1FFHqGfQE
Message-ID: <CAAbOScmnazEgEgt6JoZh==jAwpKamqie3V3A7fpZ36xV01pobA@mail.gmail.com>
Subject: Re: [PATCH] tools/power x86_energy_perf_policy: fix cpuid for i686
To: Benson Leung <bleung@chromium.org>
Cc: len.brown@intel.com, lucas.demarchi@profusion.mobi,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 22:15, Benson Leung wrote:
> --- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
> +++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
>
> +void cpuid (unsigned int info, unsigned int *eax, unsigned int *ebx,
> +           unsigned int *ecx, unsigned int *edx)

static (maybe inline?), and probably want to adjust the style by
dropping the spaces before the open paren in this func
-mike
