Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2ILDRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 23:17:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46462 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654Ab2ILDRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 23:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <1347368559-31329-4-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	<1347368559-31329-1-git-send-email-arnd@arndb.de>
	<1347368559-31329-4-git-send-email-arnd@arndb.de>
Date: Wed, 12 Sep 2012 08:47:22 +0530
X-Google-Sender-Auth: TO6eIc56w0KygIJTXkhoUz-ocWE
Message-ID: <CAOh2x=me+wSxsODv5SzyfKGJjk4C4bspg5O7WQarnEsZwqEsgA@mail.gmail.com>
Subject: Re: [PATCH 16/16] ARM: spear: move platform_data definitions
From: viresh kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 6:32 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
>
> This moves such data out of the spear include directories
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Cc: spear-devel@list.st.com
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
