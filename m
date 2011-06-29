Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1F2GEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 02:04:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:43370 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1F2GEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 02:04:43 -0400
Subject: Re: [PATCH] jffs2: use mutex_is_locked() in __jffs2_flush_wbuf()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jun 2011 09:05:34 +0300
In-Reply-To: <1309206090-2805-1-git-send-email-khoroshilov@ispras.ru>
References: <1309206090-2805-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-2.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1309327538.23597.97.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-28 at 00:21 +0400, Alexey Khoroshilov wrote:
> Use a helper to test if a mutex is held instead of a hack with
> mutex_trylock().
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Pushed to l2-mtd-2.6.git, thanks.

-- 
Best Regards,
Artem Bityutskiy

