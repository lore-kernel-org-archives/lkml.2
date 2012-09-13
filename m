Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2IMLS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 07:18:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54978 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab2IMLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:18:24 -0400
MIME-Version: 1.0
In-Reply-To: <1347461906-13527-12-git-send-email-arnd@arndb.de>
References: <1347461906-13527-1-git-send-email-arnd@arndb.de>
	<1347461906-13527-12-git-send-email-arnd@arndb.de>
Date: Thu, 13 Sep 2012 16:48:23 +0530
X-Google-Sender-Auth: WazQrf8iHG9fOsPZoB1JlZtI8MY
Message-ID: <CAOh2x=nn5XFv7H9CfbStBD+1xcqnKUA0KcxGrL9aGKLVGP4dCw@mail.gmail.com>
Subject: Re: [PATCH v9 11/13] ARM: SoC: convert spear13xx to SoC descriptor
From: viresh kumar <viresh.kumar@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Shiraz Hashim <shiraz.hashim@st.com>,
        spear-devel@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Convert the spear13xx platform to use the SoC descriptor to provide
> its SMP and CPU hotplug operations.
>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
> Cc: Shiraz Hashim <shiraz.hashim@st.com>
> Cc: spear-devel@list.st.com
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
