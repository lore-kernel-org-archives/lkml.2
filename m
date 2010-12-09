Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab0LIWoc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:44:32 -0500
Received: from mail-iw0-f172.google.com ([209.85.214.172]:61815 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0LIWoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:44:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WZ1nPzU8pBU52ciVMSCxjjGh8QZCZbsxoNXnSEznchFJLtamxO4U0aMxOspZnzhe71
         NAxt568qotmKtvI/wPKsLasno3AA0wMZV2w9u6W92H25hd415i8aUYdgFNdeOrNr4nmG
         7nxpXKTp8qWS6QvfyINozNvERBKt+ZxKy5EOs=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1012092329480.25880@swampdragon.chaosbits.net>
References: <AANLkTik4W+UxgyPjVyHDeEFTRCkXdDBQ9obgPkpnhzGW@mail.gmail.com> <alpine.LNX.2.00.1012092329480.25880@swampdragon.chaosbits.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 9 Dec 2010 14:39:08 -0800
Message-ID: <AANLkTikc_u4NhxdGzwQMjbEe12qYmhq481amazTK-JRc@mail.gmail.com>
Subject: Re: Start dropping PCMCIA from compat-wireless for 2.6.38+
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 2:31 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> On Thu, 9 Dec 2010, Luis R. Rodriguez wrote:
>
>> I'm going to start dropping PCMCIA stuff from compat-wireless as I
>> don't think we have any users of it nor interest to keep backporting
>> it. This entails dropping drivers like orinoco, b43 PCMCIA support,
>> libertas, as well as bluetooth bluecard_cs, bluecard_cs, dtl1_cs,
>> bt3c_cs and of course CONFIG_SSB_PCMCIAHOST. If you are a user please
>> yell now.
>>
> Yelling.
> While I'm not personally a user, my mother is. She still has an old IBM
> Thinkpad 600 laptop with a PCMCIA card in it that uses the orinoco driver.

And you have your mother using compat-wireless?

  Luis
