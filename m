Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab1GASOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:14:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59948 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1GASOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:14:36 -0400
Message-ID: <4E0E0D22.4020008@gmail.com>
Date: Fri, 01 Jul 2011 20:08:34 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Sergiu Iordache <sergiu@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] char drivers: ramoops dump_oops platform data
References: <1309483720-1407-1-git-send-email-sergiu@chromium.org> <1309483720-1407-2-git-send-email-sergiu@chromium.org>
In-Reply-To: <1309483720-1407-2-git-send-email-sergiu@chromium.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/07/2011 03:28, Sergiu Iordache ha scritto:
> The platform driver currently allows setting the mem_size and mem_address.
> Since dump_oops is also a module parameter it would be more consistent
> if it could be set through platform data as well.
>
> Change-Id: I27e541a51c9722047c4163bf408e778caa77ecc9
> Signed-off-by: Sergiu Iordache<sergiu@chromium.org>
> ---

Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
