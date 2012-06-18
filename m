Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab2FRPaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 11:30:22 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46127 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab2FRPaU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 11:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF44C1.70500@itdev.co.uk>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
 <1339992522-22073-23-git-send-email-djkurtz@chromium.org> <4FDF44C1.70500@itdev.co.uk>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Mon, 18 Jun 2012 23:29:59 +0800
X-Google-Sender-Auth: Mej_N7wMA2IH46hb6k-RIHC1wnA
Message-ID: <CAGS+omDgwEYMOPxsk4gjbZSO7ocz=PPzqtowBEsfnRb=0ogi4w@mail.gmail.com>
Subject: Re: [PATCH 22/22 v4] Input: atmel_mxt_ts - parse T6 reports
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:09 PM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Daniel Kurtz wrote:
>> The normal messages sent after boot or NVRAM update are T6 reports,
>> containing a status, and the config memory checksum.  Parse them and dump
>> a useful info message.
>
> This can cause a lot of dmesg output - for instance you get 2 messages per
> calibration, and the chip can trigger them itself if noise suppression or
> anti-touch calibration are enabled. So perhaps dev_dbg()?

Sounds good to me.

>
> --
> Nick Dyer
> Software Engineer, ITDev Ltd
