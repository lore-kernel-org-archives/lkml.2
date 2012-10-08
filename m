Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2JHPgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:36:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43325 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2JHPgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:36:36 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Alex Dubov <oakad@yahoo.com>, Linux-Next <linux-next@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Fixes for ms_block
Date: Mon,  8 Oct 2012 17:36:20 +0200
Message-Id: <1349710582-5410-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAMuHMdW7zfM1CxkXTCq2=ErkaAAxGVFyQSZdH3jwvUXr_8oOsg@mail.gmail.com>
References: <CAMuHMdW7zfM1CxkXTCq2=ErkaAAxGVFyQSZdH3jwvUXr_8oOsg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finally found time to send the fix for the compile issue on m68k
Among with small cosmetic fix to remove unused field that slipped thorough.

Do you know if my driver will be merged in 3.7 or later?
I hope that the compile issue which I should have handled earlier is not to blame.

