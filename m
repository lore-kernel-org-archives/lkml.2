Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2FSSkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:40:47 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:60401 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:40:45 -0400
MIME-Version: 1.0
In-Reply-To: <1340072156-6225-2-git-send-email-anton.vorontsov@linaro.org>
References: <20120619021050.GA19387@lizard>
	<1340072156-6225-2-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 19 Jun 2012 11:40:43 -0700
X-Google-Sender-Auth: oYzoEn_TS6z6a0at0H_EtwWh8RU
Message-ID: <CAGXu5jLyrajq0omxUd5Au1Jm3EFiz1gBF9jqsfbG1iJtoCKA9w@mail.gmail.com>
Subject: Re: [PATCH 2/7] pstore/ram: Fix error handling during przs allocation
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:15 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> persistent_ram_new() returns ERR_PTR() value on errors, so during
> freeing of the przs we should check for both NULL and IS_ERR() entries,
> otherwise bad things will happen.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
