Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab1HPFpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 01:45:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:64474 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab1HPFpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 01:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <1313454275-5604-7-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
	<1313454275-5604-7-git-send-email-me@akshayjoshi.com>
Date: Tue, 16 Aug 2011 08:45:31 +0300
X-Google-Sender-Auth: NH4F4XUqZ_evUvQVwujqQI4Gf_0
Message-ID: <CAOJsxLEUt2rOCe-Q-01WkDu0sKRFwogR8p-mxQTb56b=FJQTeg@mail.gmail.com>
Subject: Re: [PATCH 7/9] Staging: Winbond: Fix parentheses in returns.
From: Pekka Enberg <penberg@kernel.org>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Chihau Chau <chihau@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 3:24 AM, Akshay Joshi <me@akshayjoshi.com> wrote:
> Removes parentheses when calling return, since return is not a function.
>
> Signed-off-by: Akshay Joshi <me@akshayjoshi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
