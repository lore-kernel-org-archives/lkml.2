Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0LSOnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:43:49 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40426 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0LSOns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:content-type
         :content-transfer-encoding;
        b=C99apjXFQ9wswbdTqQpbQ2Ww/NEnbQ/sFknS0jS1ZODEKH2euwFFYld5SObVu/zL47
         TaRKxqLkacI84Re4eBx018AahFWFf0kRDWoEZuZyxE8cDg5yaaz5md7YJhAaQv8tzqK5
         4oNpUwm9i0EiMWOMDA6hv9nzvzO/FqWvdBq6U=
MIME-Version: 1.0
In-Reply-To: <20101219130001.GB5790@liondog.tnic>
References: <20101219130001.GB5790@liondog.tnic>
From: Seblu <seblu@seblu.net>
Date: Sun, 19 Dec 2010 15:43:27 +0100
X-Google-Sender-Auth: 70NqRNOZzbpzaR2lFHRKhUboC7Y
Message-ID: <AANLkTi=sQHprR_JONneN1F+3Y4Oa+cbuzXaZ+kJfuQJJ@mail.gmail.com>
Subject: Re: [PATCH] ACPI battery: Fix sysfs oops when removing battery
To: Borislav Petkov <bp@alien8.de>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <len.brown@intel.com>, Seblu <seblu@seblu.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 2:00 PM, Borislav Petkov <bp@alien8.de> wrote:
> Hi guys,
>
> I get the oops below on 37-rc6. Here's a possible fix:
>
Hi Boris,

I've the same oops when unpluging my battery with my laptop still
powered (i guess i never do that before).
On my laptop, your patch remove the oops.
Thanks !


-- 
Sébastien Luttringer
www.seblu.net
