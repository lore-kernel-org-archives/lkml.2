Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab1CHEsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 23:48:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53583 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab1CHEsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 23:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=utVM0DdwII6O6SYlB/77rao2eJWqdeGNmDgKDSZJQGFdGzbPUdFrfB+iR2eiyVLVi9
         aTempIkdrZFEZAjEcbJehhf+6YwKxoKH+Q+C2C4W3tSPA0FMIngRlGH1dEqiff6SNb1M
         MtJG4aPEjfJl53bgE5cIs2fsE0WhDYqzY7HSQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
References: <1299556809-16194-1-git-send-email-vinaysawal@gmail.com>
	<20110308042601.GX22723@ZenIV.linux.org.uk>
	<AANLkTi==7wv6mrL5OWkGKxyc7GbKPH5+kgkCBNUcj3im@mail.gmail.com>
Date: Mon, 7 Mar 2011 20:48:50 -0800
Message-ID: <AANLkTi=bLX_mz6fRJxWEcfwpq9T+7gYximLJrdY1K1EY@mail.gmail.com>
Subject: Re: [PATCH] FC: cifs: Initialized an uninitialized variable
From: Vinay Sawal <vinaysawal@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 8:38 PM, Steve French <smfrench@gmail.com> wrote:
> On Mon, Mar 7, 2011 at 10:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Mon, Mar 07, 2011 at 08:00:09PM -0800, Vinay Sawal wrote:
>>> Removed a compile time warning by initializing an uninitialized variable.
>>
>>> -     int rc;
>>> +     int rc = -EFAULT;
>>
>> Why is that the right thing to do?  Other than "it made the compiler to
>> STFU, therefore it is Good(tm)", please.
>
> Hard to disagree with Al's logic, although changing the scope of rc to
> within the for loop might also make both your compiler happy and more
> sense.   In any case, I prefer real bug fixes.

Completely agree. Thanks for the clarification. Sorry for the inconvenience.

Thanks,
Vinay




>
>
> --
> Thanks,
>
> Steve
>
