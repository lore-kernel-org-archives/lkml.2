Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231Ab1DPTyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 15:54:15 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:61791 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1DPTyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 15:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hkz6A7bhUZEkaceeikN3fZK5GYki6HN7x7MxWHcMuljOseUkOP1VqGVjyIKy7gna9I
         w3BIgt89PDtSr5G0baBaH+sxsxMzElDoDsIKVV9SoCIWWSdD+s1vsrrC04aRtG7GIC6u
         pwOkZhBefATKggSGDWSoDGKJ3ZCGl96MefswA=
MIME-Version: 1.0
In-Reply-To: <81798.1302983165@localhost>
References: <BANLkTi=GXro_xEiRyzZY86kWM9duJ3KAUQ@mail.gmail.com>
	<BANLkTi=2aRu6x3uZtpMvPd2BSpYpkT5yfQ@mail.gmail.com>
	<20110416135912.GA1044@merkur.ravnborg.org>
	<BANLkTi=wdDsrV+ikoxLhnTpLhQTuVKW0mA@mail.gmail.com>
	<61322.1302964434@localhost>
	<BANLkTimSa7=HiSKET4FSR5zqa1mXf2xGFw@mail.gmail.com>
	<62853.1302966525@localhost>
	<BANLkTi=pZPvDbffuW1X2qVVP_xk5FzmrQQ@mail.gmail.com>
	<BANLkTin9ggGY9GWOf2_nYmYUsnovmgz82A@mail.gmail.com>
	<81798.1302983165@localhost>
Date: Sat, 16 Apr 2011 21:54:06 +0200
Message-ID: <BANLkTim5wLnP6eYmKL2VaaSCZmuZ=2TQ7w@mail.gmail.com>
Subject: Re: Kbuild: how to cleanly retrieve information compilation about the
 last build
From: Francis Moreau <francis.moro@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 9:46 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sat, 16 Apr 2011 17:57:23 +0200, Francis Moreau said:
>
>> The user modify a file, then instead of calling 'make' (because he
>> forgets) run the script that send the kernel image through the net on
>> a test machine. Since the user had already compiled the kernel before,
>>  the kernel image exists but is outdated.
>
> As I said, this is an example of a broken development environment, or
> possibly a broken developer. :)
>

ok I think you can just ignore that thread now, this and what you said
below is just hmm, not revelant for me and for what I asked for.

>> How can a script detect this case if it doesn't call 'make' in its turn ?
>
> Why do you care about detecting it without calling make?  Just go ahead and
> *do* it, if the kernel is up to date it won't take long.  With a completely
> cold cache, it takes about 90 seconds on my laptop.

Really, what kind of laptop is it ?

Are you compiling the kernel with just allnoconfig ?

Seriously, I now think that what you say is totaly irrevelant, please
just ignore my question.
-- 
Francis
