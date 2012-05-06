Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab2EFCn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 22:43:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58416 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab2EFCnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 22:43:24 -0400
MIME-Version: 1.0
In-Reply-To: <4FA5665D.80304@itdev.co.uk>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <1334755319-21365-10-git-send-email-djkurtz@chromium.org> <4FA5665D.80304@itdev.co.uk>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Sun, 6 May 2012 10:43:03 +0800
X-Google-Sender-Auth: PiyZGErGeIEmKTu-voZ-LQslRo8
Message-ID: <CAGS+omCGaCujKbhbf8vUwa0K26jGFHzYJc7m_cx3fUBcUpsO6A@mail.gmail.com>
Subject: Re: [PATCH 09/14 v3] Input: atmel_mxt_ts - refactor get info
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 1:41 AM, Nick Dyer <nick.dyer@itdev.co.uk> wrote:
> Hi Daniel-
>
> Daniel Kurtz wrote:
>> -     dev_info(&client->dev,
>> -                     "Family ID: %d Variant ID: %d Version: %d Build: %d\n",
>> -                     info->family_id, info->variant_id, info->version,
>> -                     info->build);
>> +     dev_info(dev, "Family ID: %d Variant ID: %d Major.Minor.Build: %d.%d.%d\n",
>> +              info->family_id, info->variant_id, info->version >> 4,
>> +              info->version & 0xf, info->build);
>
> The canonical format for the Atmel firmware versions has the build number
> in hex, eg. 2.0.AA
>
> So it should be %d.%d.%02X

Nick,
Thanks!  Will update.  Or perhaps %u.%u.%02X ?
-Daniel

>
> cheers
>
> Nick
