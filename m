Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab1DAENd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 00:13:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42043 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DAENc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 00:13:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=KQ21QtGBF4FH6siT8Ml/uri3c6pbY1qUxuGRMjGJObdYbFxxfxFlxbs40nqjw8W+m3
         7rkItapFDGinusbM5Tzrs5oJ5ZPgPX6WUQdJGOAUgLE9AnUdPUOyUNQWHevFDRJYJ08E
         ffxRn3RIIsXsYWQe5r9vMy7TVuh1dA3KTMA8o=
MIME-Version: 1.0
In-Reply-To: <4D952A9E.6070109@canonical.com>
References: <1301606810-11001-1-git-send-email-tim.gardner@canonical.com>
	<20110331143512.2bd5703b.akpm@linux-foundation.org>
	<4D952A9E.6070109@canonical.com>
Date: Fri, 1 Apr 2011 04:13:31 +0000
X-Google-Sender-Auth: M6rRM1GU9SwJga3KhqXdLSm2rew
Message-ID: <AANLkTin+3wVJYL3XkKBLVaCF65qvpc_3ntCh0zwEA+Ra@mail.gmail.com>
Subject: Re: [PATCH V2] Raise default hard ulimit on number of files to 4096
From: Dan Kegel <dank@kegel.com>
To: tim.gardner@canonical.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 1:30 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> On 03/31/2011 03:35 PM, Andrew Morton wrote:
>>
>> ^^ how not to write a changelog.
>
> It seemed like plagiarism to just copy Dan's argument, but now here you have
> it.

I don't mind one bit.  Very happy to see this change going in.
- Dan
