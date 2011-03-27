Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1C0Dw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 23:52:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36590 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1C0DwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 23:52:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=FM6pVALIzRYtaUG3w4MNWUdB5nz1rdt8fawxTdipNwsTue39cHPzEOnwxL4A6GflhL
         W6dml8KyvPTx6eH8iBYwG4A5EQOTqXddtYU1ImuPB1xAtOiT6TM/nSfJd7yFpXhcVgWw
         qgSdUvAiOvk6rXgvw2SANVuBzX6iPBpsjXZb4=
MIME-Version: 1.0
In-Reply-To: <201103262151.47061.arnd@arndb.de>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com>
 <201103261154.18619.arnd@arndb.de> <AANLkTik7qzFC_WQPrJAMbV0b6-+CTNfP6CcQnK6BKiWn@mail.gmail.com>
 <201103262151.47061.arnd@arndb.de>
From: Mike Frysinger <vapier@gentoo.org>
Date: Sat, 26 Mar 2011 23:52:04 -0400
X-Google-Sender-Auth: 2p9TXzPbw3ovgjN-EizRncHq2xI
Message-ID: <AANLkTikyGwaUYdRbqiKiMWmyRbajbb22C7AgRHhz=wJu@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 16:51, Arnd Bergmann wrote:
> On Saturday 26 March 2011 18:55:39 Mike Frysinger wrote:
>> >> i would add an ABI field here too so if in the future we want to add
>> >> stuff, we can do so without adding new ioctls.  like "u16 version; u16
>> >> flags;".  then in the ioctl, if version isnt 0, we return ENOTSUP.  in
>> >> the future, we can add flags or bump the version.
>> >
>> > No, versioned APIs are just a pain to maintain, it's easier to add
>> > new ioctl commands when necessary.
>> > Note that the kernel would always have to support all versions of
>> > the API anyway.
>>
>> adding at least a flags field then should be fine
>
> Fine with me, if you can name at least one possible use for a flag.

i tend to assume that i cant think of all cases when i first write up
something, so better to leave a hole for the future ;)
-mike
