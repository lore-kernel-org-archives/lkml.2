Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0HPHAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:00:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54089 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0HPHAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:00:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] init/main.c: remove __releases(kernel_lock) notations
Date: Mon, 16 Aug 2010 08:59:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.92; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
References: <1281867959-9843-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1281867959-9843-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008160859.27049.arnd@arndb.de>
X-Provags-ID: V02:K0:6pEZDosQLHo0S455g5kcFWmhI4Fpk/I/CkBI5QgqSBJ
 1euvfr8B8kT0EDyQMFYQeVngd2E58prkoAiv2Ly8F03eOkst5D
 vN+LfUIaueNLnfBpaVG+QXH42nqNK5e5prd7IVAI1vqH3d9XPy
 PS0zlY9OOxHj9xPPZcN1DqK5teplQGS1Mot8Y+VisGXCU0jcyQ
 wdAtVG3mi2SPzwknp5eSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 August 2010 12:25:59 Namhyung Kim wrote:
> 
> commit 5e3d20a68f63fc5a310687d81956c3b96e488b84 removed BKL from the startup
> path so these notations should be removed also.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
