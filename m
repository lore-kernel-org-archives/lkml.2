Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0KNKL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 05:11:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61394 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0KNKL1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 05:11:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RVwztW2KAGRWCf1H8i9BxibLHXtSHvlVImJ+vZHH/3xQmRf+cnTWNXpxiX4gkn2N9D
         Y4E73LHHyasGFseGwlMReeSM01XA0ooz86p8uRffukzI3B45X9pyc7x1jIfSgwtPsvvv
         hhHbFz47/OJ6TsN/4i2QOervbkFzIJjjeqvZM=
MIME-Version: 1.0
In-Reply-To: <4CDE86C3.9080407@ru.mvista.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-21-git-send-email-catalin.marinas@arm.com>
	<4CDE86C3.9080407@ru.mvista.com>
Date: Sun, 14 Nov 2010 10:11:26 +0000
X-Google-Sender-Auth: YaUuIaPDwWTqNI3qJsWqjQzXpJo
Message-ID: <AANLkTing1GK9F3rCYUn3sPjxyy0s8nNpFg7yaULn3kCh@mail.gmail.com>
Subject: Re: [PATCH v2 20/20] ARM: LPAE: Add the Kconfig entries
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2010 12:38, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> On 12-11-2010 21:00, Catalin Marinas wrote:
>> +config ARM_LPAE
>> +       bool "Support for the Large Physical Address Extension"
>> +       depends on MMU&&  CPU_V7
>> +       help
>> +         Say Y if you have an ARMv7 processor supporting the LPAE page
>> table
>> +         format and you would like access memory beyond the 4GB limit.
>
>   Maybe "like to access"?

Yes, thanks.

-- 
Catalin
