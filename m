Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1F1GcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 02:32:24 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59791 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab1F1GbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 02:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <1309224113-21818-3-git-send-email-sergiu@chromium.org>
References: <1309224113-21818-1-git-send-email-sergiu@chromium.org>
	<1309224113-21818-3-git-send-email-sergiu@chromium.org>
Date: Tue, 28 Jun 2011 08:30:57 +0200
Message-ID: <BANLkTi=g=ApNi9GWuWmYY6p6OrQGHpn-CA@mail.gmail.com>
Subject: Re: [PATCH 2/3] char drivers: ramoops dump_oops platform data
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Sergiu Iordache <sergiu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/28 Sergiu Iordache <sergiu@chromium.org>:
> The platform driver currently allows setting the mem_size and mem_address.
> Since dump_oops is also a module parameter it would be more consistent
> if it could be set through platform data as well.
>
> Signed-off-by: Sergiu Iordache <sergiu@chromium.org>
> ---

It makes sense.

Marco
