Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2JZEp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:45:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48993 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755377Ab2JZEp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:45:26 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <508A122F.3090304@gmail.com>
References: <201210240847.52417.linux@rainbow-software.org> <450396555.xT2D53NWjT@vostro.rjw.lan> <5e64035c-9ee0-4e76-a348-d4f9f6c7b198@email.android.com> <20121024210941.3c7d2cfb@pyramind.ukuu.org.uk> <508A122F.3090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Enable A20 using KBC for some MSI laptops to fix S3 resume
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 25 Oct 2012 21:44:59 -0700
To: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <e3c7bcc1-5562-4fb9-ab34-a8f1b391c34d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My guess is that Windows explicitly enables A20 on resume.  We should do that too, really... with the current heavily unified realmode code it should be easy - let me hack up a patch in the morning.

Robert Hancock <hancockrwd@gmail.com> wrote:

>On 10/24/2012 02:09 PM, Alan Cox wrote:
>> On Wed, 24 Oct 2012 12:36:04 -0700
>> "H. Peter Anvin" <hpa@zytor.com> wrote:
>>
>>> Minor concern: it should do the wait for ready before sending each
>command.
>>
>> Can we get a command line to do this quirk too - it strikes me that
>if
>> the MSIs rely upon it then it may be something Windows always does so
>> will be useful to try on other problem machines as an experiment.
>
>I agree, one has to keep in mind the age-old question "how does Windows
>
>work?" since it surely has no such quirk. I'd say we're sometimes too 
>quick to add these DMI quirks when a more general solution would be 
>somehow figure out how the Linux behavior differs from what Windows is 
>doing.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
