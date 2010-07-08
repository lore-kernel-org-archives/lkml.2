Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0GHU3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:29:32 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36035 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0GHU3a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IgeLWAMcPl9OzvWPd36iDvIhVqLfN84UCJFWpG1aSqAD4/gCE7OPMMy0dtMFimwd4a
         q3qJRpFNxZUvYOo2yfr8nAhwjtEEC6JjS2RR4MXqJAdRys55PjRwKJlGTXBU1cHs1ebP
         w74KrPInazFIC7nIlaxT2cHYlGluYuqpx3z2k=
MIME-Version: 1.0
In-Reply-To: <20100708193013.GA3464@kroah.com>
References: <1277594847-19171-1-git-send-email-silvagustavo@users.sourceforge.net>
	<4C29CF3F.4070500@ge.com>
	<4C31A352.10807@ge.com>
	<20100708193013.GA3464@kroah.com>
Date: Thu, 8 Jul 2010 15:29:29 -0500
Message-ID: <AANLkTikVdusBQePKK0C_txmto9bnD_s7QYEetPP4WlwR@mail.gmail.com>
Subject: Re: [PATCH 4/4] Staging: vme: devices: fix coding style issues in 
	vme_user.c
From: Gustavo Silva <silvagustavosilva@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, devel@driverdev.osuosl.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/8 Greg KH <greg@kroah.com>:
> On Mon, Jul 05, 2010 at 10:18:10AM +0100, Martyn Welch wrote:
>> Martyn Welch wrote:
>> > Gustavo Silva wrote:
>> >
>> >> This is a patch to the vme_user.c file that fixes up the following
>> >> issues:
>> >>
>> >> WARNING: please, no space before tabs                                              x 12
>> >> ERROR: code indent should use tabs where possible                          x 15
>> >> WARNING: braces {} are not necessary for single statement blocks           x  2
>> >> WARNING: printk() should include KERN_ facility level                              x  3
>> >> ERROR: "foo * bar" should be "foo *bar"                                            x  1
>> >> ERROR: space required before the open brace '{'                                    x  3
>> >> WARNING: space prohibited between function name and open parenthesis '('   x  1
>> >> ERROR: spaces required around that '=' (ctx:VxV)                           x  2
>> >> ERROR: spaces required around that '<' (ctx:VxV)                           x  2
>> >> ERROR: space required after that ',' (ctx:VxV)                                     x  3
>> >> ERROR: spaces required around that '?' (ctx:VxW)                           x  1
>> >> ERROR: space required before the open parenthesis '('                              x  1
>> >> WARNING: braces {} are not necessary for single statement blocks           x  2
>> >>
>> >>
>> >>
>> >
>> > This looks very familiar - I'm sure there was a patch already on the
>> > mailing list doing this, but it has some issues which I don't think were
>> > ever addressed. This one looks good though.
>> >
>> >
>> Hmm, seems the earlier patch was fixed up and is now in linux-next, sorry.
>
> Yeah, this doesn't apply :(
>
> thanks,
>
> greg k-h
>

Oh OK,

Thanks everybody for your answers.
I will still trying more patches :)

Thanks and best regards,
Gustavo Silva
