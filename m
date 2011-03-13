Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab1CMD7b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 22:59:31 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab1CMD72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 22:59:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SGtvQJjfRUBdN9D5Gg3e7P4UlXfy5r4BceqwBBWf8dV9fG/uiRXI9D0BDQEv1uTbp5
         PPu0rALE58zYiAiFvvDZaXtQFPfVBf+j6eE5ywMkX/GdUWl9cCqZPADkK2CdCtStl7D9
         Su1JOxza5rHkNRA/TEbYDHydUzs3gnE/25Ze8=
MIME-Version: 1.0
In-Reply-To: <20110312014749.GB2164@joana>
References: <AANLkTinN=eYJB3wF9jw7vbbTtUgOzr8oap4+i21Uei5X@mail.gmail.com>
	<20110312014749.GB2164@joana>
Date: Sun, 13 Mar 2011 11:59:27 +0800
Message-ID: <AANLkTimckJ5tYv2Fvy+RgTPbP3SFex2+4MxE+Rn2314H@mail.gmail.com>
Subject: Re: [2.6.38-rc8, patch] fix hci_dev_list locking
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gustavo,

On 12 March 2011 09:47, Gustavo F. Padovan <padovan@profusion.mobi> wrote:
> Hi Daniel,
>
> * Daniel J Blueman <daniel.blueman@gmail.com> [2011-03-09 00:07:54 +0800]:
>
>> No response from original post, and it missed getting taken into -rc7
>> and -rc8, so repost:
>>
>> Release acquired lock on error path, fixing potential hang up.
>
> I already have a patch like this one in my tree, thanks anyway. :)

I guess I'm not looking in the right public tree, but I still couldn't
detect the fix in:
http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-2.6.git
or:
http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git

Thanks,
  Daniel
-- 
Daniel J Blueman
