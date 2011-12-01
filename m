Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1LAKxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 05:53:10 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:43012 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751622Ab1LAKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 05:53:08 -0500
Message-ID: <4ED75C5A.4070508@ru.mvista.com>
Date: Thu, 01 Dec 2011 14:52:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: nicolas.pitre@linaro.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: add default value for PHYS_OFFSET Kconfig setting
References: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1322711557-8279-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01.12.2011 7:52, Paul Gortmaker wrote:

> Commit 1b9f95f8ade9efc2bd49f0e7b9dc61a038ac3eef introduced the new

    Please also cite that commit's summary in parens.

> Kconfig for PHYS_OFFSET but it did not specify a default value.

> This has the undesired side effect of breaking an implictly used
> trick for updating defconfigs on the fly for routine buildtesting
> across all arch and all platforms, i.e.

>    cp /path/to/somedefconfig .config ; yes "" | make oldconfig

> In particular, the at91x40_defconfig will enter an infinite loop
> with the above, since there is no default value, and conf will just
> keep asking for one, and "yes" will keep feeding in a line return.

> Signed-off-by: Paul Gortmaker<paul.gortmaker@windriver.com>

WBR, Sergei

