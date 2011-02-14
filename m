Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1BNKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 05:16:59 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50428 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1BNKQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 05:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=VCybegv1IOptxeq/rvVM4unePSFiKrxYicyHb81boU28KET/wbPk24mWZHu5J2RVhK
         t2Svh5/I8A4T0AhKCL3jKSIvUdUygBgx5XhExoeDJ6bG0SJQIHyhuqyKWnjwQkfRFa8C
         DX7idyQO1BMSgeh40b4wUzDqwjB5oNxU1OPOc=
MIME-Version: 1.0
In-Reply-To: <1297436787.2760.47.camel@localhost>
References: <1297418437-23553-1-git-send-email-antony@niisi.msk.ru> <1297436787.2760.47.camel@localhost>
From: Guillaume LECERF <glecerf@gmail.com>
Date: Mon, 14 Feb 2011 11:16:36 +0100
X-Google-Sender-Auth: 1aoKjrep6VLtH9yK0raBT_1ToJE
Message-ID: <AANLkTikD3sWpuLGr6De3k7Hr-QZc_N0P+6F5xd=JJfR6@mail.gmail.com>
Subject: Re: [PATCH] mtd: jedec_probe: initialise make sector erase command variable
To: dedekind1@gmail.com
Cc: Antony Pavlov <antony@niisi.msk.ru>, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

2011/2/11 Artem Bityutskiy <dedekind1@gmail.com>:
> Pushed to l2-mtd-2.6.git, thanks.

Maybe it should be sent to -stable ?

-- 
Guillaume LECERF
GeeXboX developer - www.geexbox.org
