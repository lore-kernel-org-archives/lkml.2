Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1DQS10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:27:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40827 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1DQS1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:27:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=YIWbszhYnkAoPj5CQhkCH+qkBi6vr82XYQt8iWQ4Xd4YgJHKK6/84zGsBkf2MAlnzS
         kKVoxsp0twWfORs68jME4JoB6Jx99Ucwolk6AlWwNzJwTOXYJ7/QDMOeQVWK3lwg+Mnl
         oJbMiy+9XlmvcNZSLVL1RQRG70df5oTLMOXQY=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: /proc/acpi/wakeup regression in 2.6.39-rc3
Date: Sun, 17 Apr 2011 20:27:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc3; KDE/4.4.5; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <20110414222525.GA24365@mac.home>
In-Reply-To: <20110414222525.GA24365@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104172027.16022.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=33472
for your bug report, please add your address to the CC list in there, thanks!

On piątek, 15 kwietnia 2011 o 00:25:25 Tino Keitel wrote:
> Hi,
> 
> with 2.6.38, I enabled wakeup from suspend to RAM with the USB keyboard
> this way:
> 
> echo USB2 > /proc/acpi/wakeup
> 
> This does not work anymore with 2.6.39-rc3. Wakeup using the keyboard
> won't work, and the USB2 line in /proc/acpi/wakeup doesn't change to
> "enabled" after the echo command.
> 
> Is this intended? If yes, what is the new way to enable keyboard
> wakeup?
> 
> Regards,
> Tino
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
