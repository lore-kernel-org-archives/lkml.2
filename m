Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab2BGLNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:13:04 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47015 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659Ab2BGLNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:13:02 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <B567DBAB974C0544994013492B949F8E3812ED4697@EXMAIL03.scwf.nsc.com>
References: <1328595786.5274.6.camel@phoenix> <B567DBAB974C0544994013492B949F8E3812ED4697@EXMAIL03.scwf.nsc.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 7 Feb 2012 19:12:41 +0800
Message-ID: <CAF+7xW=Y2kVCXHhGFM5YNLAKE05MctcC4ZoJiq6KEagrpV9fHg@mail.gmail.com>
Subject: Re: [PATCH RFC] leds: lm3530: Fix setting pltfm->als_vmax
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch makes sense and fixes wrong range of the ALS input voltage.
> It works well on the real board.
> Thanks.
>
> Acked-and-tested-by: Milo(Woogyom) Kim <milo.kim@ti.com>
>
> BTW, I'd suggest that 'pltfm' is replaced with 'pdata' if below patch has been updated.
> [PATCH v4 5/5] leds-lm3530: replace pltfm with pdata.

Well, I will redo the patch if Andrew takes your patch serial first.
But I guess Andrew may take this one first for 3.3.

Regards,
Axel
