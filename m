Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab0I0HWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 03:22:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab0I0HWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 03:22:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH RESEND] init/main.c: remove BLK notations
Date: Mon, 27 Sep 2010 09:22:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5+; KDE/4.5.1; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1285571214-6965-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1285571214-6965-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009270922.11631.arnd@arndb.de>
X-Provags-ID: V02:K0:dHP3vy7/tCxPYcK7svKChGe8CkqNOFojQBjJeLC7ZwT
 hIkGJQUFaNxtyq722m9e+38ZE11taA4Ul6hsST9SKmn+ncnvEr
 9QGW3pero94pwlZ+o7UlazifHqsH231YKysVA1UKIScF/VDArC
 puWrIyGXkdJXq00MZ+yACCR3Z2oUMEdoyfrHlxf3mczdm6cgoX
 rgj5ukWuwL5eIaGRuFdkA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 09:06:54 Namhyung Kim wrote:
> According to commit 5e3d20a68f63fc5a310687d81956c3b96e488b84
> (init: Remove the BKL from startup code) these sparse notations
> should be removed also.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

I've applied it to my bkl/config series now. Thanks!

	Arnd
