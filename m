Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557Ab1E3QwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:52:17 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61456 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1E3QwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Z/BOGuU7Ty5cJsUgZza9oaxAHLfUQL2jUNwWdLuHWv93c3wuix+Sr0YsYA7c6wyTh2
         y4yXLLImcMO93kTd79bQ6TCOWHWqnq8XO2e8EBXTOcL4dK8GnMn7l9FrBO5aFQQQL9Hc
         sLlqVRGVYrJJ7dLYG3CP1dUdHjqXJ6foJnW+Q=
MIME-Version: 1.0
In-Reply-To: <4DE3C652.5090309@zytor.com>
References: <1305248699-2347-1-git-send-email-daniel.blueman@gmail.com>
	<69e8f8a9-4e8b-4c02-b566-304ff837d166@email.android.com>
	<BANLkTi=h5f6o3iVK24sQ20xYYQAMbLavMg@mail.gmail.com>
	<BANLkTik9BtnXxsOGKuhmoUFsKPbhBwXr3A@mail.gmail.com>
	<4DE3C652.5090309@zytor.com>
Date: Tue, 31 May 2011 00:52:15 +0800
Message-ID: <BANLkTinnEPKC+Nb7zK_PswU+M=sNPxWCig@mail.gmail.com>
Subject: Re: [PATCH] x86: Add Dell E5420 reboot quirk
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2011 00:31, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/30/2011 07:43 AM, Daniel J Blueman wrote:
>>
>> Without this patch, rebooting is like Russian roulette; with quite a
>> few of these laptops in the field, perhaps it is better to enable the
>> quirk unless you think there may be an issue in the kernel preventing
>> correct behaviour that I could debug?
>>
>> On the other hand, Dell may later fix the BIOS AML (seen with the
>> excellent fwts) just as the cure for cancer is found. If they do, I'll
>> buy whiskey too.

> Enabling the quirk is the right thing; however, if ACPI worked I'd have
> preferred it since we just switched to ACPI as the default.

Indeed - the new and default ACPI reboot method works perfectly in
3.0-rc1, whereas with 2.6.39, it didn't, so no further need for this
patch then.

Thanks again,
  Daniel
-- 
Daniel J Blueman
