Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2GaN6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:58:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58295 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2GaN6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <1343742860-16213-5-git-send-email-damien.cassou@lifl.fr>
References: <1343742860-16213-1-git-send-email-damien.cassou@lifl.fr> <1343742860-16213-5-git-send-email-damien.cassou@lifl.fr>
From: Mike Frysinger <vapier@gentoo.org>
Date: Tue, 31 Jul 2012 09:57:57 -0400
X-Google-Sender-Auth: TbWtbsz7gX-0pnuAUWScZHCi_9k
Message-ID: <CAMjpGUdo0SavFWR_tk50_6nZMsJmxYO5BxH9Fp=UTw5sW-0+Rw@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers/video/bfin-t350mcqb-fb.c: use devm_ functions
To: Damien Cassou <damien.cassou@lifl.fr>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        kernel-janitors@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 9:54 AM, Damien Cassou <damien.cassou@lifl.fr> wrote:
> The various devm_ functions allocate memory that is released when a driver
> detaches.  This patch uses these functions for data that is allocated in
> the probe function of a platform device and is only freed in the remove
> function.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
