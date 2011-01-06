Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1AFN4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 08:56:31 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:33334 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1AFN4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 08:56:30 -0500
Date: Thu, 6 Jan 2011 14:56:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Build regressions/improvements in v2.6.37
Message-ID: <alpine.DEB.2.00.1101061452590.7101@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of build error/warning regressions/improvements in
v2.6.37[1] compared to v2.6.36[2].

Summarized:
  - build errors: +51/-17
  - build warnings: +158/-138

JFYI, when comparing v2.6.37 to v2.6.37-rc8[3], the summaries are:
  - build errors: +4/-50
  - build warnings: +36/-128

Note that there may be false regressions, as the logs for v2.6.36 are
incomplete.  Still, they're build errors/warnings.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.37.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.

[1] http://kisskb.ellerman.id.au/kisskb/head/3595/ (108 configs)
[2] http://kisskb.ellerman.id.au/kisskb/head/3363/ (97 out of 108 configs)
[3] http://kisskb.ellerman.id.au/kisskb/head/3578/ (108 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
