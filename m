Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1HIIoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 04:44:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39879 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1HIIoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 04:44:32 -0400
MIME-Version: 1.0
In-Reply-To: <1312834049-29910-2-git-send-email-per.forlin@linaro.org>
References: <1312834049-29910-1-git-send-email-per.forlin@linaro.org>
	<1312834049-29910-2-git-send-email-per.forlin@linaro.org>
Date: Tue, 9 Aug 2011 10:44:31 +0200
Message-ID: <CAJ0pr18bsmoRUAs59zsTtW8Qn7qn=mBbsx3iXnmFEwomHM-JPA@mail.gmail.com>
Subject: Re: [PATCH --mmotm v5 1/3] fault-inject: export fault injection functions
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>, akpm@linux-foundation.org,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linaro-dev@lists.linaro.org, linux-mm@kvack.org,
        Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2011 22:07, Per Forlin <per.forlin@linaro.org> wrote:
> export symbols fault_should_fail() and fault_create_debugfs_attr() in order
> to let modules utilize the fault injection
This patch is already merged in mainline too.
Unfortunately I left a typo here. It says fault_should_fail() in the
commit message but the function in the patch is called only
should_fail(). This is already in rc1 so I guess we have to live with
this typo.
