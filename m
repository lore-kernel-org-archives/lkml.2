Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2FYN1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:27:08 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab2FYN1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:27:06 -0400
Message-ID: <4FE86727.5010400@linaro.org>
Date: Mon, 25 Jun 2012 15:27:03 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Lists Linaro-dev <linaro-dev@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linux-next@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Lee <rob.lee@linaro.org>
Subject: linux-next : cpuidle - could you add my tree please
References: <4FDEE98D.7010802@linaro.org> <4FDF2D58.9010006@ti.com>
In-Reply-To: <4FDF2D58.9010006@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Stephen,

we discussed last week to put in place a tree grouping the cpuidle
modifications [1]. Is it possible to add the tree ?

git://git.linaro.org/people/dlezcano/cpuidle-next.git #cpuidle-next

It contains for the moment Colin Cross's cpuidle coupled states.

Thanks in advance
  -- Daniel

[1] https://lkml.org/lkml/2012/6/18/113
