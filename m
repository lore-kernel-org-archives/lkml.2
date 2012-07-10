Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab2GJMBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 08:01:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab2GJMBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 08:01:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH v4 0/8] Function tracing support for pstore
Date: Tue, 10 Jul 2012 12:01:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
References: <20120710001004.GA22744@lizard>
In-Reply-To: <20120710001004.GA22744@lizard>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207101201.08699.arnd@arndb.de>
X-Provags-ID: V02:K0:qDG1XEdch0zZ5B0CsbK2TxEviCeIYlrYKV6rc/ipw7f
 uJciJVe3LdN41Lav6TwMWFMdBIpyJi9yU9iDEBKyPMdRRg5rnf
 KPf01MmfX0Ir6Di16BIW+2YE1HrA2S7W1uK9WEekpJ6lBaIj3U
 TYF9qUTeOigCGyd/MlMUIso2dJQpLc45//20WLdtc16pN+ajuQ
 s+YZi8wuMOVgRmq+tx64o6amyLZfZYnEMORbk1PrC2OBVxuEWW
 MCLUsZaj7eVGLEabVSHM8DpMtrzZwHBoD88ufHJMhzfgCIJwWv
 Jr6f7PApy3g3hgMm7XpgSbSGgm8KCy2+iiYYZ/XIDkIb+qHHxc
 m74rn4+qaXRTbEgYSDT0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 July 2012, Anton Vorontsov wrote:
> With this support kernel can save functions call chain log into a
> persistent ram buffer that can be decoded and dumped after reboot
> through pstore filesystem. It can be used to determine what function
> was last called before a hang or an unexpected reset (caused by, for
> example, a buggy driver that abuses HW).

I just looked at the patches, and they are all well implemented. I could
find nothing wrong with the implementation. As to the question of whether
we want this functionality I have to leave that to the tracing people.

	Arnd
