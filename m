Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab0LUDYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 22:24:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461Ab0LUDYs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 22:24:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=S5QYtmbQi2cVhWoVChzb4ke0Qzk/6Ypmhh/uNm6b4OtqyzZZBFoia1A+Xn7RLhEMUe
         wuxLQ0zEmI7CpP7+9WQVZJANtSc0jRFnhxcTJ+pLTU6/BIaCedv9Xo6q90fc7VudeZsI
         qfeJwZmtXQKQx3BwI7XfOV/MACZkQwh3jPbJ0=
MIME-Version: 1.0
In-Reply-To: <1292896861.2300.288.camel@rui>
References: <20101219130001.GB5790@liondog.tnic> <1292896861.2300.288.camel@rui>
From: Seblu <seblu@seblu.net>
Date: Tue, 21 Dec 2010 04:24:26 +0100
X-Google-Sender-Auth: gWOnLWJYlr8swg81d8CgWUofHmo
Message-ID: <AANLkTi=0ZU_eHQpUHwny=TZn31iH0GJq7tCXhPqs3WE4@mail.gmail.com>
Subject: Re: [PATCH] ACPI battery: Fix sysfs oops when removing battery
To: Zhang Rui <rui.zhang@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "Brown, Len" <len.brown@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 3:01 AM, Zhang Rui <rui.zhang@intel.com> wrote:
> On Sun, 2010-12-19 at 21:00 +0800, Borislav Petkov wrote:
>> Hi guys,
>>
>> I get the oops below on 37-rc6. Here's a possible fix:
>>
> does this happen every time when you unload the battery driver?
>
on my laptop (dell e6410), with 4 tests, this append every times.

-- 
Sébastien Luttringer
www.seblu.net
