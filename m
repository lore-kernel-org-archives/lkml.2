Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab1LETYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:24:49 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33840 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab1LETYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:24:48 -0500
MIME-Version: 1.0
In-Reply-To: <20111125230321.GA12373@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
	<1680176.R2HCxgKt4B@pali-elitebook>
	<20111125230321.GA12373@oksana.dev.rtsoft.ru>
Date: Mon, 5 Dec 2011 21:24:46 +0200
Message-ID: <CAMP44s34dDC8dTTL2cv0BG+73JXu17cdUPDb3P7WkctWi8ZsgQ@mail.gmail.com>
Subject: Re: [PATCH] rx51: add bq27200 i2c board info
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        linux-kernel@vger.kernel.org,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 26, 2011 at 1:03 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> Cc'ing Tony Lindgren.
>
> Tony, OK to pass this via battery git tree?

Tested-by: Felipe Contreras <felipe.contreras@nokia.com>

BTW. The current code has already plenty of #if's. I don't see
anything wrong with that.

-- 
Felipe Contreras
