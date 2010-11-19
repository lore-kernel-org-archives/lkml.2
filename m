Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab0KSLIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:08:06 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55227 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KSLIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=nNkMkfvO9j6OPTzrpWqlPJcOz49pahsGWTk1IULa7mdK8J3GtYhJXHv/OCBXZSE2t5
         mfXB5YW9PHXfwjsnVfX9b8xA68XV1HfKhY57AkwyyCb/tRp63hHPPQrvI4UymKwm95BS
         hcQe+t/I4sOll0rhqq6kpKL+X6maNwAliXGm0=
MIME-Version: 1.0
In-Reply-To: <20101119014029.GA26429@july>
References: <20101119014029.GA26429@july>
Date: Fri, 19 Nov 2010 11:08:02 +0000
X-Google-Sender-Auth: nGY6gpMi-2mEcHTMyPdPlMynUWY
Message-ID: <AANLkTinqvbPB5ijJnMGB1FP08WUMSUKFY_qZhgZaVUci@mail.gmail.com>
Subject: Re: [PATCH] ARM: l2x0: Check the correct address range
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 November 2010 01:40, Kyungmin Park <kmpark@infradead.org> wrote:
> From: Boojin Kim <boojin.kim@samsung.com>
>
> When flush or clean the 1MiB, it doesn't flush or clean all since it doesn't check the correct address. So Check the correct address range.

This line is very long.

The patch looks fine otherwise. I think the optimal value would be
smaller than the whole cache size but it depends on many things.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
