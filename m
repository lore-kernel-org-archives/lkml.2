Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0FXTVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:21:19 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39332 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0FXTVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=tMbACOL8WF3tx3/j5LgpM92C9FFmgGgF4EJRXZ2KCWFp728KuTmTpUWORaSXihMMqD
         grKjpJOetO7VlikD5GxhifuK97g7Evm7baec72O/XMF1jgLbEyAPAqvPxkb2VVI9ft+T
         zwarH251CTq8aFcy6GC2+gcvSCzz59Hyp+yfg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimVb6kAxvVdtTcxlofYqu1m24XEBlvYY8OKBgFu@mail.gmail.com>
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com> 
	<1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com> 
	<20100622165509.GB11336@tux> <AANLkTikHiPKPD5myvn8bycPAS4f9rBkPvbag6if7p23O@mail.gmail.com> 
	<20100624185614.GA6031@tux> <AANLkTim4mjw0BFshK_4RS6oDLLQMH_BF7BklU7EhETSj@mail.gmail.com> 
	<20100624191218.GC6031@tux> <AANLkTimVb6kAxvVdtTcxlofYqu1m24XEBlvYY8OKBgFu@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 24 Jun 2010 12:20:56 -0700
X-Google-Sender-Auth: JilK8ti2xBeuRX4O5guipDS0wDE
Message-ID: <AANLkTikrNs3uFPgi_rBKKZ30F1JQt9iLYpIZ0_32afb6@mail.gmail.com>
Subject: Re: [PATCH] mm: kmemleak: Change kmemleak default buffer size
To: Sankar P <sankar.curiosity@gmail.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
       Sujith Manoharan <Sujith.Manoharan@atheros.com>,
       Senthil Balasubramanian <senthilkumar@atheros.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 12:17 PM, Sankar P <sankar.curiosity@gmail.com> wrote:
> On Fri, Jun 25, 2010 at 12:42 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Thu, Jun 24, 2010 at 12:01:51PM -0700, Sankar P wrote:
>>> On Fri, Jun 25, 2010 at 12:26 AM, Luis R. Rodriguez
>>> <lrodriguez@atheros.com> wrote:
>>> > On Thu, Jun 24, 2010 at 12:31:11AM -0700, Sankar P wrote:
>>> >> On Tue, Jun 22, 2010 at 10:25 PM, Luis R. Rodriguez
>>> >> <lrodriguez@atheros.com> wrote:
>>> >> > On Mon, Jun 21, 2010 at 11:58:29PM -0700, Sankar P wrote:
>>> >> >> If we try to find the memory leaks in kernel that is
>>> >> >> compiled with 'make defconfig', the default buffer size
>>> >> >> seem to be inadequate. Change the buffer size from
>>> >> >> 400 to 1000, which is sufficient in most cases.
>>> >> >>
>>> >> >> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
>>> >> >
>>> >> > What's your full name? Please read the "Developer's Certificate of Origin 1.1"
>>> >> > It says:
>>> >> >
>>> >> > then you just add a line saying
>>> >> >
>>> >> >        Signed-off-by: Random J Developer <random@developer.example.org>
>>> >> >
>>> >> > using your real name (sorry, no pseudonyms or anonymous contributions.)
>>> >> >
>>> >> >
>>> >> > Also you may want to post on a new thread instead of using this old thread
>>> >> > unless the maintainer is reading this and wants to pick it up.
>>> >> >
>>> >>
>>> >> In our part of the world, we dont have lastnames. We just use the
>>> >> first letter of our father's name as the last name.
>>> >
>>> > Oh wow, what part of the world is that? Interesting.
>>> >
>>>
>>>
>>> It is in a place called "Tamil Nadu" in India. See
>>> http://en.wikipedia.org/wiki/Indian_name (First paragraph end)
>>
>> Odd, I visited Tamil Nadu for a while and met quite a few folks who
>> have full last names, like the ones Cc'd. Does this differ between
>> area or what?
>>
>
> Thiagarajan, Manoharan, Balasubramanian <= these are all first names.
> Probably they are using their Father's full name as their last name.

And their first names are what then?

  Luis
