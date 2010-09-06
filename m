Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0IFO2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 10:28:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56205 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0IFO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 10:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fSa7HuOeSAhYekaItfV/tZXl8M378ik1Y0s4miYvn3FC0LyQzonXwgvKOQ+9VTSa3V
         rigFhxqVttiLkP0ucF9HS40NlPBQsov46urnmNxCV7nmTXBSJqFBFj1dzsleOKNacjuK
         DRjhETJQtncl7rFH4V1gwudfOOG59sYT9+2eU=
MIME-Version: 1.0
In-Reply-To: <20100905084504.7dae4e13@tlielax.poochiereds.net>
References: <AANLkTinM5N-MOO9fZT9+P3YARwWrfGS+ZFdHGHEoybqs@mail.gmail.com>
	<20100905084504.7dae4e13@tlielax.poochiereds.net>
Date: Mon, 6 Sep 2010 09:28:18 -0500
Message-ID: <AANLkTin-NCqpaeOHw=EVFsNUg5zAJ_29ikLn3uiFLD8r@mail.gmail.com>
Subject: Re: 2.6.36-rc3 NULL pointer dereference crypto_destroy_tfm+0x50/0x70
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Andrew Hendry <andrew.hendry@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 5, 2010 at 7:45 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Sun, 5 Sep 2010 18:30:46 +1000
> Andrew Hendry <andrew.hendry@gmail.com> wrote:
>
>> Started hitting this since rc3.
>>
>> System has 6 cifs mounts from the one server, during shutdown they get
>> unmounted and gives this error.
>> If manually unmounting one at a time with a gap inbetween it doesn't
>> seem to happen.
>>

yes - as Jeff indicated, a part of the cifs kernel crypto patches has problems.
Key question is whether it is better to back out the fix until next release
(which also will remove the change which moved cifs to using the kernel
crypto routines) or take Shirish's fixes for the problem you describe.



-- 
Thanks,

Steve
