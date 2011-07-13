Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1GMOds (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:33:48 -0400
Received: from void.printf.net ([89.145.121.20]:48488 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab1GMOdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:33:47 -0400
From: Chris Ball <cjb@laptop.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.ke,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v6] mmc: documentation of mmc non-blocking request usage and design.
References: <1310325719-2151-1-git-send-email-per.forlin@linaro.org>
Date: Wed, 13 Jul 2011 10:33:31 -0400
In-Reply-To: <1310325719-2151-1-git-send-email-per.forlin@linaro.org> (Per
	Forlin's message of "Sun, 10 Jul 2011 21:21:59 +0200")
Message-ID: <m2wrfm2qtg.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Per,

On Sun, Jul 10 2011, Per Forlin wrote:
> Documentation about the background and the design of mmc non-blocking.
> Host driver guidelines to minimize request preparation overhead.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Pushed v6 to mmc-next for 3.1, thanks.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
