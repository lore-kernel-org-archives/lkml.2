Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0GIWEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:04:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54397 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab0GIWEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=U5ixwWXpOcEZLZ3bWJb/Napn6tLZq27X7MsJO04O6gva08bYPh29R06NA57ucuo343
         ALWB5k23iq3jwH6Q8PXUIz3xj7F0h6XGe1htgPH+iVXg4ms4AH32iRk95ABIwI/PxjaQ
         UZww0ksfsG3RFYt9QtwPSA9ZzM+xBR5n5T1hk=
MIME-Version: 1.0
In-Reply-To: <4C3793FB.4080907@gmail.com>
References: <4C3680D1.5070601@lwfinger.net>
	<4C378AD9.1070602@gmail.com>
	<4C379323.1090004@lwfinger.net>
	<4C3793FB.4080907@gmail.com>
Date: Fri, 9 Jul 2010 15:04:20 -0700
X-Google-Sender-Auth: iagzt_LlA23qeYRJ9MDM7yP0LdQ
Message-ID: <AANLkTikFmeXz9og4t98jm6QcAdRa6rIeCAv3oeFnTgd8@mail.gmail.com>
Subject: Re: Warning message when using sparse
From: Christopher Li <sparse@chrisli.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-Sparse <linux-sparse@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 2:26 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 07/09/2010 11:22 PM, Larry Finger wrote:
>> Obviously, I pulled the wrong git tree. I got the one from the wiki.
>> When I built the one from the kernel.org tree, all is well.
>
> Both are from kernel.org. But the one I sent is a Chris'es "fork" with
> my and other fixes.
>

Yes, you caught me slacking off. It is time to cut a new release
and flush all the bits into the official tree.

Chris
