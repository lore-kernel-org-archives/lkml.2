Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab0KUXF5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:05:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39442 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326Ab0KUXF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:05:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QwMIzeIk1eeWPMQMOEatrpcvAf6Y242DEL390u7O3uCxwDOw7DDt7mtBdHfn56ftyD
         Iw31jLg47MWWa1EjKHTNKDD0feqIj6zVkecTKf+C5rskXjiCjJdDt49qfqfLS/8Xz4iq
         7euvm8warnU3ylEjeZAzdD9s/EXlXYwObprn8=
Message-ID: <4CE9A5D0.4080701@gmail.com>
Date: Mon, 22 Nov 2010 00:05:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: missing 700 MB of RAM
References: <icbqak$32o$1@ID-44327.news.uni-berlin.de>
In-Reply-To: <icbqak$32o$1@ID-44327.news.uni-berlin.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2010 08:02 PM, Andreas Hartmann wrote:
> I've got 8 GB RAM installed, but linux reports 7,3 GB. Where is the
> missing RAM (700 MB)?
...
> The motherboard is a GA-MA78GM-S2H (64bit, AMD) with a on board Radeon
> HD 3200 VGA card. The card uses 256 MB of RAM - so 444 MB of RAM are
> missing. Where are they gone?

Hi, ask your BIOS:

> BIOS-provided physical RAM map:
> BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
> BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
> BIOS-e820: 0000000000100000 - 00000000afde0000 (usable)
> BIOS-e820: 00000000afde0000 - 00000000afde3000 (ACPI NVS)
> BIOS-e820: 00000000afde3000 - 00000000afdf0000 (ACPI data)
> BIOS-e820: 00000000afdf0000 - 00000000afe00000 (reserved)
> BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
> BIOS-e820: 0000000100000000 - 0000000230000000 (usable)

It reports 7677M of usable mem. Or maybe your loader is cheating on you?
I doubt so...

regards,
-- 
js
