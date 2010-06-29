Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab0F2LIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 07:08:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48311 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0F2LIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 07:08:19 -0400
To: Jens Axboe <axboe@kernel.dk>
CC: xiaosuo@gmail.com, tim.gardner@canonical.com,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] splice fixes
Message-Id: <E1OTYfk-0008GY-PJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 29 Jun 2010 13:08:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix bugs that affect real-world users of splice(2) and
sendfile(2) interfaces.

Not sure if some or all of them are appropriate for 2.6.35 and/or
-stable?

Thanks,
Miklos
