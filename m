Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1BNLHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:07:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33725 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1BNLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:07:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jCC0qxQBm8XsLYaN9m6MZYnh5q0ficxM44FTBU5mQxGgP2QvTekwUQMe547Q39Qw6L
         R1/ax3bJQXl/XBhXWh+nhfaOwXVKURUmz4UyyueCga2PITAcNQtnSIfMKYkRn2I+pVuv
         W+DBrYGYpCpwWKMy1B45EhBUHPCsa9NfBlly0=
Subject: Re: [PATCH] mtd: jedec_probe: initialise make sector erase command
 variable
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Guillaume LECERF <glecerf@gmail.com>
Cc: Antony Pavlov <antony@niisi.msk.ru>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikD3sWpuLGr6De3k7Hr-QZc_N0P+6F5xd=JJfR6@mail.gmail.com>
References: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru>
	 <1297436787.2760.47.camel@localhost>
	 <AANLkTikD3sWpuLGr6De3k7Hr-QZc_N0P+6F5xd=JJfR6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 13:05:58 +0200
Message-ID: <1297681558.2854.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 11:16 +0100, Guillaume LECERF wrote:
> Hi.
> 
> 2011/2/11 Artem Bityutskiy <dedekind1@gmail.com>:
> > Pushed to l2-mtd-2.6.git, thanks.
> 
> Maybe it should be sent to -stable ?

OK, I'll add a "cc stable" tag,

thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

