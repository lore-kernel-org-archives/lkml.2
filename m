Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1G0QhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:37:04 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33768 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1G0Qg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E2FCE2A.3000909@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
	<4E2EBF63.8050208@suse.cz>
	<20110726080443.62196869.rdunlap@xenotime.net>
	<4E2F0735.1070403@suse.cz>
	<20110726112824.b357c756.rdunlap@xenotime.net>
	<CACqU3MWOjjB0RiWLWS8yf0u0gRqOL3JP0StyrtP1kbA+i92SfA@mail.gmail.com>
	<CACqU3MWopoJcd+5ELWEDp6_GvVpEjOHLnkcj4s_fHT5unp+MtA@mail.gmail.com>
	<20110726213536.1f56f0e3.rdunlap@xenotime.net>
	<4E2FCE2A.3000909@suse.cz>
Date: Thu, 28 Jul 2011 00:36:57 +0800
Message-ID: <CAM_iQpXE4vQNoS=_SEcPWObOcdNDbxpfy__YG=b7qAh2=9e3Vw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(), KCONFIG_BUILTIN()
 and KCONFIG_MODULE()
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Arnaud Lacombe <lacombar@gmail.com>,
        linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 4:36 PM, Michal Marek <mmarek@suse.cz> wrote:
>
> Good idea. Is anyone against
> IS_ENABLED(CONFIG_FOO)
> IS_ENABLED_BUILTIN(CONFIG_FOO)
> IS_ENABLED_MODULE(CONFIG_FOO)
> ?

How about IS_ENABLED() IS_BUILTIN() IS_MODULE()?

Thanks.
