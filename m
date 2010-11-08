Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab0KIKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:16:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0KIKQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:16:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: vt8500-wm8505-linux-kernel@googlegroups.com
Subject: Re: [PATCH 6/6 v2] ARM: Add support for the display controllers in VT8500 and WM8505
Date: Mon, 8 Nov 2010 09:47:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Charkov <alchark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <1289147348-31969-6-git-send-email-alchark@gmail.com>
In-Reply-To: <1289147348-31969-6-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201011080947.37522.arnd@arndb.de>
X-Provags-ID: V02:K0:uR7lSrYmCCTnXKMh82WtoywwtBz+HM530m7HUkV+ZDA
 yjOGoJlG4u+YY5uAgoufm6IhrPS1tTMXv9gwDMym9wIhU9b8Ey
 hd3G73C+7bWTMUELhKl9UaLES7j8jtRybI1NhzLlM2DOzSF6uv
 0c1EBA2bjD1Mqba+K6TyTcWIjOXhkyn0NXDNpoL+pQ26MWbZ3L
 ldrgU+GeU9XJvkhXLilJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 November 2010, Alexey Charkov wrote:
>  drivers/video/Kconfig         |   26 +++
>  drivers/video/Makefile        |    3 +
>  drivers/video/vt8500lcdfb.c   |  452 +++++++++++++++++++++++++++++++++++++++++
>  drivers/video/vt8500lcdfb.h   |   34 +++
>  drivers/video/wm8505fb.c      |  438 +++++++++++++++++++++++++++++++++++++++
>  drivers/video/wm8505fb_regs.h |   76 +++++++
>  drivers/video/wmt_ge_rops.c   |  186 +++++++++++++++++
>  drivers/video/wmt_ge_rops.h   |    5 +

>From a very brief look, the two drivers look rather similar. What is the
reason to have separate drivers instead of just one?

Could you perhaps take the common parts and move them into a third module
that exports symbols to be used by the two drivers?

	Arnd

