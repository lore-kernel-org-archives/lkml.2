Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab0LUKK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 05:10:26 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:58587 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933625Ab0LUKKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 05:10:24 -0500
Message-ID: <4D107CF0.5090007@kernel.dk>
Date: Tue, 21 Dec 2010 11:09:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Stefan Schmidt <stefan@datenfreihafen.org>
CC: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block/cciss: Close continue statement with semicolon
 to fix build
References: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org>
In-Reply-To: <1292924526-10850-1-git-send-email-stefan@datenfreihafen.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 10:42, Stefan Schmidt wrote:
> This fixes the following build error:
> drivers/block/cciss.c: In function ‘cciss_revalidate’:
> drivers/block/cciss.c:2839: error: expected ‘;’ before ‘if’
> make[2]: *** [drivers/block/cciss.o] Error 1

It's already included in Linus' git.

-- 
Jens Axboe

