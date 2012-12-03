Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LCXya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:54:30 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2LCXy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:54:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 1/5] asm-generic/mmu.h: Remove unused vmlist field from mm_context_t
Date: Mon, 3 Dec 2012 23:54:10 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mark Salter <msalter@redhat.com>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-c6x-dev@linux-c6x.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, linux-arch@vger.kernel.org
References: <1351765467-29244-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1351765467-29244-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201212032354.10573.arnd@arndb.de>
X-Provags-ID: V02:K0:tMMFfg8oDn1f0AYNUOEK99aBp51LFuE238c8C0MD9oX
 xh24scp4Mj/8RbpFDf9Ys0zm+Zd8RD5Gzy1CM3FI6nIvm0epSV
 7/vRjDxkzPhx2cKmv6JEnV8BMnFOsa84KpK4AiA84yLi+2Au5A
 gfmaQsq6NXEjEBalL2qhpxiEGmmXSsXotT431i1pAmhx/pi5il
 uKppVWGw2vL+Wvm1rnmZ3yweM/ILcRsMpR1ikEZtHd1CU2UByB
 xa7HAO0o0T3xBoXos7Hdx3f6IRm5Kl9Q4vdtqhJaGxLb5aYguN
 68FifNJ4Db6dMH1tbotWSu7xkZ7OcoQE/v5FgBdhNh03Iy6dab
 ppNZDqDAdNo1Yle8ECb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2012, Lars-Peter Clausen wrote:
> Nothing is using the vmlist field in mm_context_t anymore. It has been removed
> from the non-generic versions over 3 years ago 8feae1311 ("NOMMU: Make VMAs per
> MM as for MMU-mode linux").
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Whole series:

Acked-by: Arnd Bergmann <arnd@arndb.de>

Do you want to include the patches in a patch set of your own, or should I put them
into the asm-generic tree?

	Arnd
