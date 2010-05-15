Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab0EORLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 13:11:38 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:64334 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab0EORLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 13:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B4CltP8CGoBhVmAOKDhytzW1BbDiYx6fyl6Qm6xDpgzBFsHoKk3HjN0nE7Pf0uKmZJ
         6ihiusQGk29fU5eruT2EazQIGXhqBLdCldALEg726zSHX2NpYzThjEPwKKsRi5XtamgG
         ilCI295eJlI2P+O8BTVYsjHUVEu1KNYbEBQYU=
MIME-Version: 1.0
In-Reply-To: <1273697523.2856.3.camel@localhost.localdomain>
References: <AANLkTin6D2GP0yJJbPYGH1AcAM9-g219rAxSyW_ZlrXV@mail.gmail.com>
	 <AANLkTikjgoBQWqvNxncMUFqWOEXtq4ePvGkvF-m0sGUE@mail.gmail.com>
	 <AANLkTimnlZYonxKzfGHZTV8vwaDptOPHEPBjNhwnV55Y@mail.gmail.com>
	 <1273540344.3843.101.camel@localhost.localdomain>
	 <AANLkTilg2cn3lAIOruz6oZE7V-9uAFDORlbvTX3qxmwF@mail.gmail.com>
	 <AANLkTilb_CGBolyv5Ps9VuhNxFZKtjck4om4G21ICaif@mail.gmail.com>
	 <1273697523.2856.3.camel@localhost.localdomain>
Date: Sat, 15 May 2010 13:11:35 -0400
Message-ID: <AANLkTinBPDY_WVGaq2LUuOzH0niRpgJ4LEpXWkwBxVqh@mail.gmail.com>
Subject: Re: PROBLEM: tickless scheduling
From: Donald Allen <donaldcallen@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Content-Type: multipart/mixed; boundary=0016e68fce5f82d5450486a5159d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e68fce5f82d5450486a5159d
Content-Type: text/plain; charset=ISO-8859-1

On Wed, May 12, 2010 at 4:52 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Wed, 2010-05-12 at 15:54 -0400, Donald Allen wrote:
>> Before doing what you asked, I ran my home-brew backup script, which
>> tars up the whole machine, save my home directory, to a big sata drive
>> in a usb shoebox. I did so by booting the most recent Arch Linux
>> install/live CD (while I use Slackware, the Slackware install CDs are
>> not suitable for this sort of thing, having very old versions of
>> things like tar). While doing so, I observed exactly the same symptoms
>> I did with the Slackware 13.1 install, which I described in the bug
>> report. So rather than messing with the hard-won custom kernel that I
>> now have installed on the netbook, I am attaching the various things
>> from /proc gathered with the Arch kernel running. Yes, it's a somewhat
>> older kernel (2.6.30), but I'm hoping that things haven't changed much
>> in tickless land. If that's not the case, then I will attempt to
>> reproduce this with the newer kernel on the Slackware 13.1 install
>> DVD. Let me know if you need me to do this. The attached tar file is
>> bzip2-compressed, so you want xjf to extract.
>
> Hmm.. Sorry, but I have another quick request. Could you send
> your /proc/interrupts output from the kernel having the problem?

Attached. This is from the 2.6.30 kernel on the Arch Linux install cd.

Here's another bit of data. As I've said previously, the problems I'm
reporting were observed on a Toshiba NB310-305 netbook with a
single-core Atom 450 processor. I just built myself a mini-ITX system
using the Intel D510MO motherboard, which provides a dual-core D510
Atom processor. The other hardware on the board is similar to the
Toshiba. I installed the same Slackware snapshot I used on the
Toshiba, and did the home directory transfer without any problem at
all with the default tickless kernel. The hardware isn't identical,
and while I don't know the internals of the Linux kernel at all, my
gut, backed up by many years of OS development work in scheduling and
memory management, is telling me that the key difference is dual- vs.
single-core. Just a guess.

Hope this helps --

/Don

>
> thanks
> -john
>
>
>

--0016e68fce5f82d5450486a5159d
Content-Type: application/octet-stream; name=interrupts
Content-Disposition: attachment; filename=interrupts
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g99vvwn30

ICAgICAgICAgICBDUFUwICAgICAgIENQVTEgICAgICAgCiAgMDogICAgICAgMTg3MiAgICAgICAx
ODc4ICAgSU8tQVBJQy1lZGdlICAgICAgdGltZXIKICAxOiAgICAgICAgMjI3ICAgICAgICAxODMg
ICBJTy1BUElDLWVkZ2UgICAgICBpODA0MgogIDg6ICAgICAgICAgNjQgICAgICAgICA2NSAgIElP
LUFQSUMtZWRnZSAgICAgIHJ0YzAKICA5OiAgICAgICAgMzQ1ICAgICAgICAzNDkgICBJTy1BUElD
LWZhc3Rlb2kgICBhY3BpCiAxMjogICAgICAxMzM4NCAgICAgIDEzMzgxICAgSU8tQVBJQy1lZGdl
ICAgICAgaTgwNDIKIDE2OiAgICAgICAgICAwICAgICAgICAgIDAgICBJTy1BUElDLWZhc3Rlb2kg
ICB1aGNpX2hjZDp1c2I1CiAxNzogICAgICAgICAgMCAgICAgICAgICAwICAgSU8tQVBJQy1mYXN0
ZW9pICAgYXRoCiAxODogICAgICAgICAgMCAgICAgICAgICAwICAgSU8tQVBJQy1mYXN0ZW9pICAg
dWhjaV9oY2Q6dXNiNAogMTk6ICAgICAgICAgIDAgICAgICAgICAgMCAgIElPLUFQSUMtZmFzdGVv
aSAgIHVoY2lfaGNkOnVzYjMKIDIyOiAgICAgICAgIDkwICAgICAgICAgODkgICBJTy1BUElDLWZh
c3Rlb2kgICBIREEgSW50ZWwKIDIzOiAgICAgICAxMzUzICAgICAgIDEzNDYgICBJTy1BUElDLWZh
c3Rlb2kgICBlaGNpX2hjZDp1c2IxLCB1aGNpX2hjZDp1c2IyCiAyNzogICAgICAgICA5NiAgICAg
ICAgIDkzICAgUENJLU1TSS1lZGdlICAgICAgYWhjaQpOTUk6ICAgICAgICAgIDAgICAgICAgICAg
MCAgIE5vbi1tYXNrYWJsZSBpbnRlcnJ1cHRzCkxPQzogICAgICAgNjI4NiAgICAgICA1ODMxICAg
TG9jYWwgdGltZXIgaW50ZXJydXB0cwpTUFU6ICAgICAgICAgIDAgICAgICAgICAgMCAgIFNwdXJp
b3VzIGludGVycnVwdHMKUkVTOiAgICAgICA1OTE5ICAgICAgIDIwMDkgICBSZXNjaGVkdWxpbmcg
aW50ZXJydXB0cwpDQUw6ICAgICAgICAgMjIgICAgICAgICAzOSAgIEZ1bmN0aW9uIGNhbGwgaW50
ZXJydXB0cwpUTEI6ICAgICAgICAxMjUgICAgICAgIDEzNSAgIFRMQiBzaG9vdGRvd25zClRSTTog
ICAgICAgICAgMCAgICAgICAgICAwICAgVGhlcm1hbCBldmVudCBpbnRlcnJ1cHRzClRIUjogICAg
ICAgICAgMCAgICAgICAgICAwICAgVGhyZXNob2xkIEFQSUMgaW50ZXJydXB0cwpFUlI6ICAgICAg
ICAgIDAKTUlTOiAgICAgICAgICAwCg==
--0016e68fce5f82d5450486a5159d--
